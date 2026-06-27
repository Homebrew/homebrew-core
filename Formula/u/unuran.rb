class Unuran < Formula
  desc "UNU.RAN - Universal Non-Uniform RANdom number generator"
  homepage "https://statmath.wu.ac.at/unuran/"
  url "https://github.com/unuran/unuran/archive/refs/tags/unuran-1.11.0.tar.gz"
  sha256 "e46c15eff050150966988ec56969526b60ce0b97120a7821aa96703d0f175623"
  license "GPL-2.0-or-later"
  head "https://github.com/unuran/unuran.git", branch: "main"

  livecheck do
    url :stable
    regex(/^unuran[._-](\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc688fd0bb04c726a41b12d0328533ff271128d42a1b8651950f89e8a1ea0406"
    sha256 cellar: :any, arm64_sequoia: "9e411035f79de2f3dd58892bf08d2a25d28c20addbefd6a222668d0015ba5f29"
    sha256 cellar: :any, arm64_sonoma:  "7b22444f06bce13d65e9ff6b7bad05dbe1d9b3d7c77191e5dfb4939c2fb53461"
    sha256 cellar: :any, sonoma:        "ebfde1d5ba197b0d7bec27c917b72265ef6f59609daaf8a187d7a780c030e203"
    sha256 cellar: :any, arm64_linux:   "369a27ae88f6f61a2dc0bee167f46b246a58b7df062e80783439bf2beff51b11"
    sha256 cellar: :any, x86_64_linux:  "30722e8980d7a9bba0f24166944fb992aae982b08c3dba912b5f996d829890b7"
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
