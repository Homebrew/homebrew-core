class Unuran < Formula
  desc "UNU.RAN - Universal Non-Uniform RANdom number generator"
  homepage "https://statmath.wu.ac.at/unuran/"
  url "https://github.com/unuran/unuran/archive/refs/tags/unuran-1.12.0.tar.gz"
  sha256 "9c8f6c5229615dc4871af11bca92fab9083f45ab66871d98031e05578e0567f9"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/unuran/unuran.git", branch: "main"

  livecheck do
    url :stable
    regex(/^unuran[._-](\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7b497736d70b7cede01b2808aeed41788d41dafc6e29267c71699cb5b0a90747"
    sha256 cellar: :any, arm64_sequoia: "14873c242df0237baa5cff64d870d2793de3c2a76eb486680a364fed9aad7f9a"
    sha256 cellar: :any, arm64_sonoma:  "7070e774e8176086fa46446f5bc3f475a02db0f1f6896abc1562ba49b270ccd3"
    sha256 cellar: :any, sonoma:        "4f818a00766a4284a1fe32f51e036ab24b68f7424fc155843a247151ecc7ca37"
    sha256 cellar: :any, arm64_linux:   "8791c122c24e7fc123629855b603aee933fe457d6f42cc500fe6d84a25fb7dc6"
    sha256 cellar: :any, x86_64_linux:  "9460190a338d36e0b1467e7c7fc5fd26e21c9bb809f1a47638c2a1f37d07ee96"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "texinfo" => :build
  depends_on "gsl"

  def install
    # force autogen.sh to look for and use our glibtoolize
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh", "--enable-shared", "--with-urng-gsl", *std_configure_args
    system "make"
    # system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <unuran.h>
      int main() {
          UNUR_DISTR *par = unur_distr_normal(NULL, 0);
          if (par == NULL) return 1;
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{formula_opt_lib("gsl")}", "-L#{lib}",
            "-lgsl", "-lgslcblas", "-lunuran", "-o", "test"
    system "./test"
  end
end
