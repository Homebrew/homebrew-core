class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://www.sandia.gov/qthreads/"
  url "https://github.com/sandialabs/qthreads/releases/download/1.21/qthreads-1.21.tar.gz"
  sha256 "428983e7423d10ca9be2830c3b3935516286b160694d1d054ed76ae12c510171"
  license "BSD-3-Clause"
  head "https://github.com/sandialabs/qthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96285a04844a48e8d9fb1b42603028838283daa73d0f128b2f5693ae26b0034f"
    sha256 cellar: :any,                 arm64_sonoma:  "e4c8067e01b5b13796c266aadef6f0b87a55eb98074f491213b4278402a84eec"
    sha256 cellar: :any,                 arm64_ventura: "d6f302754331981d1eb27dc3171ac6d959abf587c8fa73f9bcf43314a1e9b979"
    sha256 cellar: :any,                 sonoma:        "350662c7facb3943957870c0769b1442c051f824512276c15ae1171eaf69d49d"
    sha256 cellar: :any,                 ventura:       "0e23710563e3ebdb83505cd7817dada31a3aafd2fa9460aace926dc022eefabb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1d37bb159cb706c38bf76372026532407eba1e1f93702147710c0d5ecffae32"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "userguide/examples"
    doc.install "userguide"
  end

  test do
    system ENV.cc, pkgshare/"examples/hello_world.c", "-o", "hello", "-I#{include}", "-L#{lib}", "-lqthread"
    assert_equal "Hello, world!", shell_output("./hello").chomp
  end
end
