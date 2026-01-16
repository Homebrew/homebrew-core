class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.2.0/SFCGAL-v2.2.0.tar.gz"
  sha256 "bb6bb77ddb58523d8c229764de23699f99c1a7011d873419afd2a67df85602a2"
  license "LGPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9c0f30ae28d7d8ef18675126864cc80f7806ecf8fefa079f29e9215c2c319c4"
    sha256 cellar: :any,                 arm64_sequoia: "2d8f5fb00b500b9bc05b286393ca03e6814c0764fe7c3b214fc6386e17f3adde"
    sha256 cellar: :any,                 arm64_sonoma:  "3d78c85d04cbf3032c2c61ae4bdebd921346635ecb1994b80a3e91daf5b115c5"
    sha256 cellar: :any,                 sonoma:        "401ad303e69a6465a0f0bef39fa8f562dbe9bdba48334648f01021b442d0f1a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5031bd5b692ff5c189cf13c444788ef9609f26b2553fbc5de60ee1d341927e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a690b79a1a0d1170b952c122f419b4ec3889a69e2f431d7a68fb4cb4774091a4"
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
