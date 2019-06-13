;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2019 Pierre Langlois <pierre.langlois@gmx.com>
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

(define-module (gnu packages wireservice)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages sphinx)
  #:use-module (gnu packages time))

;; Base package definition for packages from https://github.com/wireservice.
;; This is done so we can share how to run tests and build documentation.
(define base-package
  (package
    (name #f)
    (version #f)
    (source #f)
    (home-page #f)
    (synopsis #f)
    (description #f)
    (build-system python-build-system)
    (native-inputs
     `(("python-nose" ,python-nose)
       ("python-sphinx" ,python-sphinx)
       ("python-sphinx-rtd-theme" ,python-sphinx-rtd-theme)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (invoke "nosetests" "tests")))
         (add-after 'install 'install-docs
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (doc (string-append out "/share/doc/"
                                        ,(package-name this-package)
                                        "-"
                                        ,(package-version this-package))))
               (with-directory-excursion "docs"
                 (for-each
                  (lambda (target)
                    (invoke "make" target)
                    (copy-recursively (string-append "_build/" target)
                                      (string-append doc "/" target)))
                  '("html" "dirhtml" "singlehtml" "text")))
               #t))))))
    (license license:expat)))

(define-public python-leather
  (package
    (inherit base-package)
    (name "python-leather")
    (version "0.3.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/wireservice/leather.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1ck3dplni99sv4s117cbm07ydwwjsrxkhdy19rnk0iglia1d4s5i"))))
    (native-inputs
     `(("python-cssselect" ,python-cssselect)
       ("python-lxml" ,python-lxml)
       ,@(package-native-inputs base-package)))
    (propagated-inputs
     `(("python-six" ,python-six)))
    (home-page "https://leather.rtfd.org")
    (synopsis "Python charting for 80% of humans")
    (description "Leather is a Python charting library for those who need
charts now and don't care if they're perfect.")))

(define-public python-agate
  (package
    (inherit base-package)
    (name "python-agate")
    (version "1.6.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/wireservice/agate.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "077zj8xad8hsa3nqywvf7ircirmx3krxdipl8wr3dynv3l3khcpl"))))
    (native-inputs
     `(("python-cssselect" ,python-cssselect)
       ("python-lxml" ,python-lxml)
       ,@(package-native-inputs base-package)))
    (propagated-inputs
     `(("python-babel" ,python-babel)
       ("python-isodate" ,python-isodate)
       ("python-leather" ,python-leather)
       ("python-parsedatetime" ,python-parsedatetime)
       ("python-pytimeparse" ,python-pytimeparse)
       ("python-six" ,python-six)
       ("python-slugify" ,python-slugify)))
    (home-page "https://agate.rtfd.org")
    (synopsis "Data analysis library")
    (description "Agate is a Python data analysis library.  It is an
alternative to numpy and pandas that solves real-world problems with readable
code.  Agate was previously known as journalism.")))

(define-public python-agate-sql
  (package
    (inherit base-package)
    (name "python-agate-sql")
    (version "0.5.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/wireservice/agate-sql.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "16q0b211n5b1qmhzkfl2jr56lda0rvyh5j1wzw26h2n4pm4wxlx2"))))
    (propagated-inputs
     `(("python-agate" ,python-agate)
       ("python-crate" ,python-crate)
       ("python-sqlalchemy" ,python-sqlalchemy)))
    (home-page "https://agate-sql.rtfd.org")
    (synopsis "SQL read/write support to agate")
    (description "@code{agatesql} uses a monkey patching pattern to add SQL
support to all @code{agate.Table} instances.")))

(define-public python-agate-dbf
  (package
    (inherit base-package)
    (name "python-agate-dbf")
    (version "0.2.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/wireservice/agate-dbf.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1y49fi6pmm7gzhajvqmfpcca2sqnwj24fqnsvzwk7r1hg2iaa2gi"))))
    (propagated-inputs
     `(("python-agate" ,python-agate)
       ("python-dbfread" ,python-dbfread)))
    (home-page "https://agate-dbf.rtfd.org")
    (synopsis "Add read support for dbf files to agate")
    (description "@code{agatedbf} uses a monkey patching pattern to add read
for dbf files support to all @code{agate.Table} instances.")))

(define-public python-agate-excel
  (package
    (inherit base-package)
    (name "python-agate-excel")
    (version "0.2.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/wireservice/agate-excel.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1k5lv21k19s7kgbj5srd1xgrkqvxqqs49qwj33zncs9l7851afy7"))))
    (propagated-inputs
     `(("python-agate" ,python-agate)
       ("python-openpyxl" ,python-openpyxl)
       ("python-xlrd" ,python-xlrd)))
    (home-page "https://agate-excel.rtfd.org")
    (synopsis "Add read support for Excel files (xls and xlsx) to agate")
    (description "@code{agateexcel} uses a monkey patching pattern to add read
for xls and xlsx files support to all @code{agate.Table} instances.")))

(define-public csvkit
  (package
    (name "csvkit")
    (version "1.0.4")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "csvkit" version))
              (sha256
               (base32
                "1830lb95rh1iyi3drlwxzb6y3pqkii0qiyzd40c1kvhvaf1s6lqk"))
              (patches (search-patches "csvkit-fix-tests.patch"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-psycopg2" ,python-psycopg2) ;; Used to test PostgreSQL support.
       ("python-sphinx" ,python-sphinx)
       ("python-sphinx-rtd-theme" ,python-sphinx-rtd-theme)))
    (inputs
     `(("python-agate-dbf" ,python-agate-dbf)
       ("python-agate-excel" ,python-agate-excel)
       ("python-agate-sql" ,python-agate-sql)
       ("python-six" ,python-six)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'install 'install-docs
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out  (assoc-ref outputs "out"))
                    (man1 (string-append out "/share/man/man1")))
               (with-directory-excursion "docs"
                 (invoke "make" "man")
                 (copy-recursively "_build/man" man1))
               #t))))))
    (home-page "https://csvkit.rtfd.org")
    (synopsis "Command-line tools for working with CSV")
    (description "csvkit is a suite of command-line tools for converting to
and working with CSV.  It provides the following commands:
@itemize
@item Input:
  @itemize
  @item @command{in2csv}: Convert various formats to CSV.
  @item @command{sql2csv}: Execute SQL commands on a database and return the
data as CSV.
  @end itemize
@item Processing:
  @itemize
  @item @command{csvclean}: Remove common syntax errors.
  @item @command{csvcut}: Filter and truncate CSV files.
  @item @command{csvgrep}: Filter tabular data to only those rows where
certain columns contain a given value or match a regular expression.
  @item @command{csvjoin}: Merges two or more CSV tables together using a
method analogous to SQL JOIN operation.
  @item @command{csvsort}: Sort CSV files.
  @item @command{csvstack}: Stack up the rows from multiple CSV files,
optionally adding a grouping value to each row.
  @end itemize
@item Output and analysis:
  @itemize
  @item @command{csvformat}: Convert a CSV file to a custom output format.
  @item @command{csvjson}: Converts a CSV file into JSON or GeoJSON.
  @item @command{csvlook}: Renders a CSV to the command line in a
Markdown-compatible, fixed-width format.
  @item @command{csvpy}: Loads a CSV file into a @code{agate.csv.Reader}
object and then drops into a Python shell so the user can inspect the data
however they see fit.
  @item @command{csvsql}: Generate SQL statements for a CSV file or execute
those statements directly on a database.
  @item @command{csvstat}: Prints descriptive statistics for all columns in a
CSV file.
  @end itemize
@end itemize")
    (license license:expat)))
