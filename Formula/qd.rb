class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://www.davidhbailey.com/dhbsoftware/"
  url "https://www.davidhbailey.com/dhbsoftware/qd-2.3.23.tar.gz"
  sha256 "b3eaf41ce413ec08f348ee73e606bd3ff9203e411c377c3c0467f89acf69ee26"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?qd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc67a1611a730d5a0e3ad87ed5c18ab92eabedf6502b849df81f2885056d64d4"
    sha256 cellar: :any,                 arm64_monterey: "c1cef2704e1fcd44953f70cdde726d584a09b4dab2ad4622783deabc6f64caf5"
    sha256 cellar: :any,                 arm64_big_sur:  "98047f6136ad8b68370755021b1e127e60b5050a6a5b903c68943527b28ecfae"
    sha256 cellar: :any,                 ventura:        "deaae413218273ffa3a41a629f7ca98eaf72a45e4ba6bfdfcc64da4f60d0ecb0"
    sha256 cellar: :any,                 monterey:       "2f324b4dd203182d4f6b4944ce69d62bcf0720365e19a77903d4829570a6b6a9"
    sha256 cellar: :any,                 big_sur:        "e9b1241f3d1d0f3b78d129ee8bd863eaaa42db2b6bfa74c5d53b419d47cfd331"
    sha256 cellar: :any,                 catalina:       "d9900fff146db8cf036730fa0ac5c6cbed48c9ea362e91875dcd3393f30093cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "551b9eac56f835c4b4a210be82d30dd2692018967c236b50bc0697820c1a7515"
  end

  depends_on "gcc" # for gfortran

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
