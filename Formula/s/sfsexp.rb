class Sfsexp < Formula
  desc "Small Fast S-Expression Library"
  homepage "https://github.com/mjsottile/sfsexp"
  url "https://github.com/mjsottile/sfsexp/releases/download/v1.4.1/sfsexp-1.4.1.tar.gz"
  sha256 "15e9a18bb0d5c3c5093444a9003471c2d25ab611b4219ef1064f598668723681"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "309d53aff505ea3cca51ada4c8820ec0aae2f41666c750131f7d4c6ec60f80d4"
    sha256 cellar: :any,                 arm64_sequoia: "f03b944967fd032f7538cafe2d1207790c47445922ecc8720b176ed8c1f747e9"
    sha256 cellar: :any,                 arm64_sonoma:  "5fff80561a38b1e7f175a8eb61f556abc10e9c3c9db5c1eff1babd21208a41ee"
    sha256 cellar: :any,                 arm64_ventura: "77e62444ee703cec04f5954922c54aa32d65a02294c3a154448d8e944c004229"
    sha256 cellar: :any,                 sonoma:        "4e312aea24c7d1274a99753d578e75cfdf1a35054082e2f2524977cbdf770969"
    sha256 cellar: :any,                 ventura:       "ab57777f8d6f986c0cd673e9ee487dd7703f12f7b2b31c0747d920c78040c2e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ff705f2b247288b7ae07ea297499af24c7d7b599359c0a4eb7f3996017e2bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e4511f902951c709a20aab4f8c56209c45c86ddf83efe86185242a0f6adadf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  uses_from_macos "m4" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <string.h>
      #include <sexp.h>
      #include <sexp_ops.h>

      int main() {
        const char *test_expr = "(test 123 (nested 456))";
        size_t len = strlen(test_expr);

        sexp_t *sx = parse_sexp((char *)test_expr, len);

        if (sx == NULL) {
          fprintf(stderr, "Failed to parse S-expression\n");
          return 1;
        }

        if (sx->ty != SEXP_LIST) {
          fprintf(stderr, "Expected list type\n");
          destroy_sexp(sx);
          return 1;
        }

        // Success if we got here
        destroy_sexp(sx);
        printf("S-expression test passed\n");
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/sfsexp", "-L#{lib}", "-o", "test", "test.c", "-lsexp"
    system "./test"
  end
end
