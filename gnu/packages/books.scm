;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2023 Artyom V. Poptsov <poptsov.artyom@gmail.com>
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

(define-module (gnu packages books)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages music)
  #:use-module (gnu packages inkscape)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texlive)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils))

(define-public book-sparc
  (package
    (name "book-sparc")
    (version "1.0.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/artyom-poptsov/SPARC")
                    (commit (string-append "v" version))))
              (sha256
               (base32
                "0crnx1cy67xbwh9n1s5zhwh96shlr6x8g67x5jb11lhakk1z0qbc"))
              (file-name (git-file-name name version))))
    (build-system copy-build-system)
    (native-inputs (list python-pygments bash-minimal perl which fontconfig))
    (inputs (list font-liberation
                  git
                  gnu-make
                  inkscape
                  lilypond
                  texlive-marvosym
                  texlive-fontspec
                  texlive-koma-script
                  texlive-trimspaces
                  texlive-acronym
                  texlive-adjustbox
                  texlive-bibtex
                  texlive-bibtexperllibs
                  texlive-bigfoot
                  texlive-circuitikz
                  texlive-collection-langcyrillic
                  texlive-glossaries
                  texlive-glossaries-extra
                  texlive-lilyglyphs
                  texlive-minted
                  texlive-multirow
                  texlive-pgf
                  texlive-pgfplots
                  texlive-subfiles
                  texlive-svg
                  texlive-t1utils
                  texlive-textpos
                  texlive-transparent
                  texlive-xetex))
    (arguments
     (list #:install-plan #~'(("sparc.pdf" "share/doc/sparc/"))
           #:phases #~(modify-phases %standard-phases
                        (delete 'check)
                        (delete 'configure)
                        (add-before 'install 'build
                          (lambda* (#:key inputs parallel-build?
                                    #:allow-other-keys)
                            (use-modules (ice-9 regex)
                                         (srfi srfi-1))
                            (let* ((src (assoc-ref inputs "source"))
                                   (rx (make-regexp
                                        "/gnu/store/(.*)-book-sparc.*"))
                                   (src-hash (match:substring (regexp-exec rx
                                                               src) 1))
                                   (random-seed (fold (lambda (ch prev)
                                                        (+ (char->integer ch)
                                                           prev)) 0
                                                      (string->list src-hash))))
                              (setenv "RANDOMSEED"
                                      (number->string random-seed))
                              (setenv "REPRODUCIBILITY" "yes"))
                            (invoke "make" "-j"
                                    (if parallel-build?
                                        (number->string (parallel-job-count))
                                        "1")))))))
    (home-page "https://github.com/artyom-poptsov/SPARC")
    (synopsis "Book on combining art and technology")
    (description
     "Science, Programming, Art and Radioelectronics Club (SPARC) is a book that
explains how to combine the topics mentined in the title to build projects.  The
book can be used to teach programming classes in colleges and to organize
workshops in hackerspaces or other community-driven spaces.  Currently the book
is available only in Russian.")
    (license license:cc-by-sa4.0)))
