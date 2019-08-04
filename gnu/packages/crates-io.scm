;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2019 Ivan Petkov <ivanppetkov@gmail.com>
;;; Copyright © 2019 Efraim Flashner <efraim@flashner.co.il>
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

(define-module (gnu packages crates-io)
  #:use-module (guix build-system cargo)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

;;;
;;; Please: Try to add new module packages in alphabetic order.
;;;

(define-public rust-autocfg
  (package
    (name "rust-autocfg")
    (version "0.1.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "autocfg" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0asl6fnc35yk5l2rxwhp25v128jgm45dp754h9z8x51b6n90w4r2"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/cuviper/autocfg")
    (synopsis "Automatic cfg for Rust compiler features")
    (description "Rust library for build scripts to automatically configure
code based on compiler support.  Code snippets are dynamically tested to see
if the @code{rustc} will accept them, rather than hard-coding specific version
support.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-bencher
  (package
    (name "rust-bencher")
    (version "0.1.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bencher" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "1x8p2xblgqssay8cdykp5pkfc0np0jk5bs5cx4f5av097aav9zbx"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/bluss/bencher/")
    (synopsis "Port of the libtest benchmark runner to Rust stable")
    (description "This package provides a port of the libtest (unstable Rust)
benchmark runner to Rust stable releases.  Supports running benchmarks and
filtering based on the name.  Benchmark execution works exactly the same way
and no more (caveat: black_box is still missing!).")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-bitflags
  (package
    (name "rust-bitflags")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bitflags" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "1zc1qb1hwsnl2d8rhzicsv9kqd5b2hwbrscrcfw5as4sfr35659x"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/bitflags/bitflags")
    (synopsis "Macro to generate structures which behave like bitflags")
    (description "This package provides a macro to generate structures which
behave like a set of bitflags.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-cfg-if
  (package
    (name "rust-cfg-if")
    (version "0.1.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cfg-if" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0csygklgz3ybpr0670rkip49zh76m43ar3k7xgypkzbzrwycx1ml"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/alexcrichton/cfg-if")
    (synopsis "Define an item depending on parameters")
    (description "This package provides a macro to ergonomically define an item
depending on a large number of #[cfg] parameters.  Structured like an
@code{if-else} chain, the first matching branch is the item that gets emitted.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-discard
  (package
    (name "rust-discard")
    (version "1.0.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "discard" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "1h67ni5bxvg95s91wgicily4ix7lcw7cq0a5gy9njrybaibhyb91"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/Pauan/rust-discard")
    (synopsis "Allow for intentionally leaking memory")
    (description "There are situations where you need to intentionally leak some
memory but not other memory.  This package provides a discard trait which allows
for intentionally leaking memory")
    (license license:expat)))

(define-public rust-doc-comment
  (package
    (name "rust-doc-comment")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "doc-comment" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "15rsqxgarfpb1yim9sbp9yfgj7p2dq6v51c6bq1a62paii9ylgcj"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/GuillaumeGomez/doc-comment")
    (synopsis "Macro to generate doc comments")
    (description "This package provides a way to generate doc comments
from macros.")
    (license license:expat)))

(define-public rust-dtoa
  (package
    (name "rust-dtoa")
    (version "0.4.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "dtoa" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0phbm7i0dpn44gzi07683zxaicjap5064w62pidci4fhhciv8mza"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/dtolnay/dtoa")
    (synopsis "Fast functions for printing floating-point primitives")
    (description "This crate provides fast functions for printing
floating-point primitives to an @code{io::Write}.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-fallible-iterator
  (package
    (name "rust-fallible-iterator")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fallible-iterator" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "1xq759lsr8gqss7hva42azn3whgrbrs2sd9xpn92c5ickxm1fhs4"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/sfackler/rust-fallible-iterator")
    (synopsis "Fallible iterator traits")
    (description "If the @code{std} or @code{alloc} features are enabled, this
crate provides implementations for @code{Box}, @code{Vec}, @code{BTreeMap}, and
@code{BTreeSet}.  If the @code{std} feature is enabled, this crate additionally
provides implementations for @code{HashMap} and @code{HashSet}.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-fnv
  (package
    (name "rust-fnv")
    (version "1.0.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fnv" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "1ww56bi1r5b8id3ns9j3qxbi7w5h005rzhiryy0zi9h97raqbb9g"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/servo/rust-fnv")
    (synopsis "implementation of the Fowler-Noll-Vo hash function")
    (description "The @code{fnv} hash function is a custom @code{Hasher}
implementation that is more efficient for smaller hash keys.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-fs-extra
  (package
    (name "rust-fs-extra")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fs_extra" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0x6675wdhsx277k1k1235jwcv38naf20d8kwrk948ds26hh4lajz"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/webdesus/fs_extra")
    (synopsis "Extra filesystem methods")
    (description "Expanding opportunities standard library @code{std::fs} and
@code{std::io}.  Recursively copy folders with recept information about
process and much more.")
    (license license:expat)))

(define-public rust-futures
  (package
    (name "rust-futures")
    (version "0.1.28")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0saq8ffjw1pwf1pzhw3kq1z7dfq6wpd8x93dnni6vbkc799kkp25"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/rust-lang-nursery/futures-rs")
    (synopsis "Implementation of zero-cost futures in Rust")
    (description "An implementation of @code{futures} and @code{streams}
featuring zero allocations, composability, and iterator-like interfaces.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-hex
  (package
    (name "rust-hex")
    (version "0.3.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hex" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0xsdcjiik5j750j67zk42qdnmm4ahirk3gmkmcqgq7qls2jjcl40"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/KokaKiwi/rust-hex")
    (synopsis "Encode and decode data to/from hexadecimals")
    (description "This crate allows for encoding and decoding data into/from
hexadecimal representation.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-itoa
  (package
    (name "rust-itoa")
    (version "0.4.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "itoa" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0zvg2d9qv3avhf3d8ggglh6fdyw8kkwqg3r4622ly5yhxnvnc4jh"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/dtolnay/itoa")
    (synopsis "Fast functions for printing integer primitives")
    (description "This crate provides fast functions for printing integer
primitives to an @code{io::Write}.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-json
  (package
    (name "rust-json")
    (version "0.11.14")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "json" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "1hj8c6xj5c2aqqszi8naaflmcdbya1i9byyjrq4iybxjb4q91mq1"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/maciejhirsz/json-rust")
    (synopsis "JSON implementation in Rust")
    (description "This crate provides a JSON implementation in Rust, reducing
friction with idiomatic Rust structs to ease interopability.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-maplit
  (package
    (name "rust-maplit")
    (version "1.0.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "maplit" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0hsczmvd6zkqgzqdjp5hfyg7f339n68w83n4pxvnsszrzssbdjq8"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/bluss/maplit")
    (synopsis "Collection of Map macros")
    (description "This crate provides a collection of @code{literal} macros for
@code{HashMap}, @code{HashSet}, @code{BTreeMap}, and @code{BTreeSet.}")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-matches
  (package
    (name "rust-matches")
    (version "0.1.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "matches" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "020axl4q7rk9vz90phs7f8jas4imxal9y9kxl4z4v7a6719mrz3z"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/SimonSapin/rust-std-candidates")
    (synopsis "Macro to evaluate whether an expression matches a pattern.")
    (description "This package provides a macro to evaluate, as a boolean,
whether an expression matches a pattern.")
    (license license:expat)))

(define-public rust-md5
  (package
    (name "rust-md5")
    (version "0.6.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "md5" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "17b2xm4h4cvxsdjsf3kdrzqv2za60kak961xzi5kmw6g6djcssvy"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/stainless-steel/md5")
    (synopsis "MD5 hash function in Rust")
    (description "The package provides the MD5 hash function.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-peeking-take-while
  (package
    (name "rust-peeking-take-while")
    (version "0.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "peeking_take_while" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "16bhqr6rdyrp12zv381cxaaqqd0pwysvm1q8h2ygihvypvfprc8r"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/fitzgen/peeking_take_while")
    (synopsis "Provides the peeking_take_while iterator adaptor method")
    (description
      "Like @code{Iterator::take_while}, but calls the predicate on a peeked
value.  This allows you to use @code{Iterator::by_ref} and
@code{Iterator::take_while} together, and still get the first value for which
the @code{take_while} predicate returned false after dropping the @code{by_ref}.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-percent-encoding
  (package
    (name "rust-percent-encoding")
    (version "2.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "percent-encoding" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0m6rkp3iy11la04p6z3492rns6n693pvmx585dvfmzzlzak2hkxs"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/servo/rust-url/")
    (synopsis "Percent encoding and decoding")
    (description "This crate provides percent encoding and decoding.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-proc-macro2
  (package
    (name "rust-proc-macro2")
    (version "0.4.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "proc-macro2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0nd71fl24sys066jrha6j7i34nfkjv44yzw8yww9742wmc8j0gfg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:cargo-inputs (("rust-unicode-xid" ,rust-unicode-xid))
        #:cargo-development-inputs (("rust-quote" ,rust-quote))))
    (home-page "https://github.com/alexcrichton/proc-macro2")
    (synopsis "Stable implementation of the upcoming new `proc_macro` API")
    (description "This package provides a stable implementation of the upcoming new
`proc_macro` API.  Comes with an option, off by default, to also reimplement itself
in terms of the upstream unstable API.")
    ;; Dual licensed.
    (license (list license:asl2.0 license:expat))))

(define-public rust-quote
  (package
    (name "rust-quote")
    (version "0.6.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "quote" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nw0klza45hf127kfyrpxsxd5jw2l6h21qxalil3hkr7bnf7kx7s"))))
    (build-system cargo-build-system)
    (arguments
      `(#:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2))))
    (home-page "https://github.com/dtolnay/quote")
    (synopsis "Quasi-quoting macro quote!(...)")
    (description "Quasi-quoting macro quote!(...)")
    ;; Dual licensed.
    (license (list license:asl2.0 license:expat))))

(define-public rust-unicode-xid
  (package
    (name "rust-unicode-xid")
    (version "0.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unicode-xid" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1z57lqh4s18rr4x0j4fw4fmp9hf9346h0kmdgqsqx0fhjr3k0wpw"))))
    (build-system cargo-build-system)
    (home-page
      "https://github.com/unicode-rs/unicode-xid")
    (synopsis "Determine Unicode XID related properties")
    (description "Determine whether characters have the XID_Start
or XID_Continue properties according to Unicode Standard Annex #31.")
    ;; Dual licensed.
    (license (list license:asl2.0 license:expat))))
