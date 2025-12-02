class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.2.0/SFCGAL-v2.2.0.tar.gz"
  sha256 "bb6bb77ddb58523d8c229764de23699f99c1a7011d873419afd2a67df85602a2"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96e20b32b551e70b2ada85525d29c9eacf71c7bd9801a596a9fc69aed2a11ccf"
    sha256 cellar: :any,                 arm64_sequoia: "edf3e6bb7675d6b66c5aa4dd86b38689aed0b7d66575b1e5d9adce8ee59115ca"
    sha256 cellar: :any,                 arm64_sonoma:  "18747f7e52f38575052dfe8f343dd806e44cb814529a38fe81d76d184afe53f4"
    sha256 cellar: :any,                 arm64_ventura: "fce83f644f244c62668e5d6e0369249058896ab3bc585853389169b9f8c2a8e5"
    sha256 cellar: :any,                 sonoma:        "5d01307845b1f4644b1d4a9b9042bfc759253a18e95ece43e5e7c1327b04b9cb"
    sha256 cellar: :any,                 ventura:       "a439a761239ed06d5895960dee7f6cc782687f5cc7f1c8990aa13e64e1305231"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ca1c0b6a601215658c7b1728b052181e77ab82784c0d5877798b91f9d4ab236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961bba19ab5213f947a89814d80823c5ef2bea78eab1551957e56b390ba7854e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    # Workaround for Boost 1.89.0 until fixed upstream
    # Issue ref: https://gitlab.com/sfcgal/SFCGAL/-/issues/306
    inreplace "CMakeLists.txt", " SFCGAL_Boost_COMPONENTS thread system ", " SFCGAL_Boost_COMPONENTS thread "

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
