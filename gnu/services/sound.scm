;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2018, 2020 Oleg Pykhalov <go.wigust@gmail.com>
;;; Copyright © 2020 Liliana Marie Prikler <liliana.prikler@gmail.com>
;;; Copyright © 2020 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2022 Maxim Cournoyer <maxim.cournoyer@gmail.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu services sound)
  #:use-module (gnu services base)
  #:use-module (gnu services configuration)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services)
  #:use-module (gnu system pam)
  #:use-module (gnu system shadow)
  #:use-module (guix diagnostics)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix records)
  #:use-module (guix store)
  #:use-module (guix ui)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pulseaudio)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:export (alsa-configuration
            alsa-service-type

            pulseaudio-configuration
            pulseaudio-service-type

            ladspa-configuration
            ladspa-service-type))

;;; Commentary:
;;;
;;; Sound services.
;;;
;;; Code:


;;;
;;; ALSA
;;;

(define-record-type* <alsa-configuration>
  alsa-configuration make-alsa-configuration alsa-configuration?
  (alsa-plugins alsa-configuration-alsa-plugins ;file-like
                (default alsa-plugins))
  (pulseaudio?   alsa-configuration-pulseaudio? ;boolean
                 (default #t))
  (extra-options alsa-configuration-extra-options ;string
                 (default "")))

(define alsa-config-file
  ;; Return the ALSA configuration file.
  (match-lambda
    (($ <alsa-configuration> alsa-plugins pulseaudio? extra-options)
     (apply mixed-text-file "asound.conf"
            `("# Generated by 'alsa-service'.\n\n"
              ,@(if pulseaudio?
                    `("# Use PulseAudio by default
pcm_type.pulse {
  lib \"" ,#~(string-append #$alsa-plugins:pulseaudio
                            "/lib/alsa-lib/libasound_module_pcm_pulse.so") "\"
}

ctl_type.pulse {
  lib \"" ,#~(string-append #$alsa-plugins:pulseaudio
                            "/lib/alsa-lib/libasound_module_ctl_pulse.so") "\"
}

pcm.!default {
  type pulse
  fallback \"sysdefault\"
  hint {
    show on
    description \"Default ALSA Output (currently PulseAudio Sound Server)\"
  }
}

ctl.!default {
  type pulse
  fallback \"sysdefault\"
}\n\n")
                    '())
              ,extra-options)))))

(define (alsa-etc-service config)
  (list `("asound.conf" ,(alsa-config-file config))))

(define alsa-service-type
  (service-type
   (name 'alsa)
   (extensions
    (list (service-extension etc-service-type alsa-etc-service)))
   (default-value (alsa-configuration))
   (description "Configure low-level Linux sound support, ALSA.")))


;;;
;;; PulseAudio
;;;

(define-record-type* <pulseaudio-configuration>
  pulseaudio-configuration make-pulseaudio-configuration
  pulseaudio-configuration?
  (client-conf pulseaudio-configuration-client-conf
               (default '()))
  (daemon-conf pulseaudio-configuration-daemon-conf
               ;; Flat volumes may cause unpleasant experiences to users
               ;; when applications inadvertently max out the system volume
               ;; (see e.g. <https://bugs.gnu.org/38172>).
               (default '((flat-volumes . no))))
  (script-file pulseaudio-configuration-script-file
               (default (file-append pulseaudio "/etc/pulse/default.pa")))
  (extra-script-files pulseaudio-configuration-extra-script-files
                      (default '()))
  (system-script-file pulseaudio-configuration-system-script-file
                      (default
                        (file-append pulseaudio "/etc/pulse/system.pa"))))

(define (pulseaudio-conf-entry arg)
  (match arg
    ((key . value)
     (format #f "~a = ~s~%" key value))
    ((? string? _)
     (string-append arg "\n"))))

(define pulseaudio-environment
  (match-lambda
    (($ <pulseaudio-configuration> client-conf daemon-conf default-script-file)
     `(("PULSE_CONFIG" . ,(apply mixed-text-file "daemon.conf"
                                 "default-script-file = " default-script-file "\n"
                                 (map pulseaudio-conf-entry daemon-conf)))
       ("PULSE_CLIENTCONFIG" . ,(apply mixed-text-file "client.conf"
                                       (map pulseaudio-conf-entry client-conf)))))))

(define (extra-script-files->file-union extra-script-files)
  "Return a G-exp obtained by processing EXTRA-SCRIPT-FILES with FILE-UNION."

  (define (file-like->name file)
    (match file
      ((? local-file?)
       (local-file-name file))
      ((? plain-file?)
       (plain-file-name file))
      ((? computed-file?)
       (computed-file-name file))
      (_ (leave (G_ "~a is not a local-file, plain-file or \
computed-file object~%") file))))

  (define (assert-pulseaudio-script-file-name name)
    (unless (string-suffix? ".pa" name)
      (leave (G_ "`~a' lacks the required `.pa' file name extension~%") name))
    name)

  (let ((labels (map (compose assert-pulseaudio-script-file-name
                              file-like->name)
                     extra-script-files)))
    (file-union "default.pa.d" (zip labels extra-script-files))))

(define (append-include-directive script-file)
  "Append an include directive to source scripts under /etc/pulse/default.pa.d."
  (computed-file "default.pa"
                 #~(begin
                     (use-modules (ice-9 textual-ports))
                     (define script-text
                       (call-with-input-file #$script-file get-string-all))
                     (call-with-output-file #$output
                       (lambda (port)
                         (format port (string-append script-text "
### Added by Guix to include scripts specified in extra-script-files.
.nofail
.include /etc/pulse/default.pa.d~%")))))))

(define pulseaudio-etc
  (match-lambda
    (($ <pulseaudio-configuration> _ _ default-script-file extra-script-files
                                   system-script-file)
     `(("pulse"
        ,(file-union
          "pulse"
          `(("default.pa"
             ,(if (null? extra-script-files)
                  default-script-file
                  (append-include-directive default-script-file)))
            ("system.pa" ,system-script-file)
            ,@(if (null? extra-script-files)
                  '()
                  `(("default.pa.d" ,(extra-script-files->file-union
                                      extra-script-files)))))))))))

(define pulseaudio-service-type
  (service-type
   (name 'pulseaudio)
   (extensions
    (list (service-extension session-environment-service-type
                             pulseaudio-environment)
          (service-extension etc-service-type pulseaudio-etc)
          (service-extension udev-service-type (const (list pulseaudio)))))
   (default-value (pulseaudio-configuration))
   (description "Configure PulseAudio sound support.")))


;;;
;;; LADSPA
;;;

(define-record-type* <ladspa-configuration>
  ladspa-configuration make-ladspa-configuration
  ladspa-configuration?
  (plugins ladspa-plugins (default '())))

(define (ladspa-environment config)
  ;; Define this variable in the global environment such that
  ;; pulseaudio swh-plugins (and similar LADSPA plugins) work.
  `(("LADSPA_PATH" .
     (string-join
      ',(map (lambda (package) (file-append package "/lib/ladspa"))
             (ladspa-plugins config))
      ":"))))

(define ladspa-service-type
  (service-type
   (name 'ladspa)
   (extensions
    (list (service-extension session-environment-service-type
                             ladspa-environment)))
   (default-value (ladspa-configuration))
   (description "Configure LADSPA plugins.")))

;;; sound.scm ends here
