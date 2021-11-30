;;; GNU Guix --- Functional package management for GNU
;;;
;;; Copyright © 2021 Artyom V. Poptsov <poptsov.artyom@gmail.com>
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

(define-module (gnu packages multiseat)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages docker)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages display-managers)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages linux)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system qt)
  #:use-module (guix build-system gnu)
  #:use-module ((guix build utils) #:select (alist-replace))
  #:use-module (ice-9 match)
  #:use-module ((srfi srfi-1) #:select (alist-delete)))

(define-public mst
  (package
    (name    "mst")
    (version "1.0.0-1e15d1f")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url    "https://gitlab.com/gkaz/mst")
                    (commit "1e15d1f")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0w0gclmmkcjh4fjkmdcbj9f5hy98yasy51dj56c0dg8rzjnaj3mg"))))
    (build-system gnu-build-system)
    ;; (build-system qt-build-system)
    (arguments
     `(#:tests? #t
       #:imported-modules
       (,@%qt-build-system-modules)
       #:modules
       ((guix build gnu-build-system)
        ((guix build qt-build-system)
         #:prefix qt:)
        (guix build utils))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'qm-chmod
           (lambda _
             ;; Make sure 'lrelease' can modify the qm files.
             (for-each (lambda (po)
                         (chmod po #o666))
                       (find-files "i18n" "\\.qm$"))
             #t))
         (add-after 'unpack 'patch
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (substitute* "mst.pro"
               (("\\$\\$\\[QT_INSTALL_BINS\\]/lrelease")
                (string-append (assoc-ref inputs "qttools")
                               "/bin/lrelease")))
             (substitute* "mst/core/components/awesome.cpp"
               (("awesome --version")
                (format #f
                        "~a/bin/awesome --version"
                        (assoc-ref inputs "awesome"))))
             (substitute* "mst/core/components/display_manager.cpp"
               (("platform::popen_read\\(\"lightdm\",")
                (format #f
                        "platform::popen_read(\"~a/sbin/lightdm\","
                        (assoc-ref inputs "lightdm"))))
             (substitute* "mst/core/components/xorg.cpp"
               (("xdpyinfo")
                (format #f
                        "~a/bin/xdpyinfo"
                        (assoc-ref inputs "xdpyinfo"))))
             (substitute* "mst/core/components/vgl.cpp"
               (("vglclient")
                (format #f
                        "~a/bin/vglclient"
                        (assoc-ref inputs "virtualgl")))
               (("vglserver_config")
                (format #f
                        "~a/bin/vglserver_config"
                        (assoc-ref inputs "virtualgl"))))
             (substitute* "mst/main.cpp"
               (("set_template_dir\\(\"/var/lib/mst/\"\\)")
                (format #f
                        "set_template_dir(\"~a/var/lib/mst/\")"
                        (assoc-ref outputs "out")))
               (("xset")
                (format #f "~a/usr/bin/xset" (assoc-ref inputs "xset"))))
             (substitute* "templates/vgl.sh.template"
               (("/var/lib/vgl/vgl_xauth_key")
                (format #f
                        "~a/var/lib/vgl/vgl_xauth_key"
                        (assoc-ref inputs "virtualgl")))
               (("/usr/lib/vglrun.vars")
                (format #f
                        "~a/usr/lib/vglrun.vars"
                        (assoc-ref inputs "virtualgl"))))
             (substitute* "templates/xinitrc.template"
               (("awesome")
                (format #f "~a/bin/awesome" (assoc-ref inputs "awesome"))))
             (substitute* (list "templates/rc.lua.template"
                                "templates/rc.lua.4.template")
               (("/usr/share/awesome")
                (format #f
                        "~a/usr/share/awesome"
                        (assoc-ref inputs "awesome")))
               (("/usr/bin/xset")
                (format #f "~a/usr/bin/xset" (assoc-ref inputs "xset"))))
             (substitute* "templates/sudoers.template"
               (("/usr/bin/bash")
                (format #f "~a/usr/bin/bash" (assoc-ref inputs "bash")))
               ;; TODO:
               ;; (("/bin/su")
               ;;  (format #f "~a/usr/bin/su" (assoc-ref inputs "")))
               (("/usr/sbin/lightdm")
                (format #f "~a/usr/sbin/lightdm" (assoc-ref inputs "lightdm")))
               (("/usr/bin/dm-tool")
                (format #f "~a/usr/bin/dm-tool" (assoc-ref inputs "lightdm")))
               (("/usr/bin/Xephyr")
                (format #f "~a/usr/bin/Xephyr" (assoc-ref inputs "xorg-server")))
               (("/usr/bin/xset")
                (format #f "~a/usr/bin/xset" (assoc-ref inputs "xorg"))))
             #t))
         (add-after 'configure 'generate-version-file
           (lambda* (#:key outputs #:allow-other-keys)
             (with-output-to-file "mst/version.h"
               (lambda ()
                 (format #t
                         "const string VERSION = \"~a\";~%"
                         version)))
             #t))
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (invoke-qmake
                     (lambda ()
                       (invoke "qmake"
                               (string-append "PREFIX=" out)
                               (string-append "BINDIR=" out "/bin")
                               (string-append "DATADIR=" out "/share")
                               (string-append "PLUGINDIR="
                                              out
                                              "/lib/qt5/plugins")))))
               (invoke-qmake)
               (let ((cwd (getcwd)))
                 (chdir "mst")
                 (invoke-qmake)
                 (chdir cwd)))
             #t))
         (add-after 'install 'qt-wrap
           (assoc-ref qt:%standard-phases 'qt-wrap)))))
    (native-inputs
     `(("automake"    ,automake)
       ("autoconf"    ,autoconf)
       ("make"        ,gnu-make)
       ("bash"        ,bash-minimal)
       ("texinfo"     ,texinfo)
       ("gettext"     ,gettext-minimal)))
    (inputs
     `(("awesome"     ,awesome)
       ("docker"      ,docker)
       ("unclutter"   ,unclutter)
       ("lightdm"     ,lightdm)
       ("bash"        ,bash-minimal)
       ("guile-udev"  ,guile-udev)
       ("virtualgl"   ,virtualgl)
       ("eudev"       ,eudev)
       ("guile"       ,guile-3.0)
       ;; ("xdialog"    ,xdialog)
       ("qtbase"      ,qtbase-5)
       ("xorg-server" ,xorg-server)
       ("xdpyinfo"    ,xdpyinfo)
       ("qttools"     ,qttools)))
    (home-page "https://gitlab.com/gkaz/mst")
    (synopsis
     "Multi-seat configurator.")
    (description
     "MST (Multi-Seat Toolkit) is a graphical multi-seat configurator and a s
set of tools that enables easy configuration of multi-seat setups.")
    (license license:gpl3)))

