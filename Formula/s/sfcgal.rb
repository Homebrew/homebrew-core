class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.2.0/SFCGAL-v2.2.0.tar.gz"
  sha256 "bb6bb77ddb58523d8c229764de23699f99c1a7011d873419afd2a67df85602a2"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb8f72224910fce0b00af1710504412ea68e7b3bfb3380d16e6122efab224dbb"
    sha256 cellar: :any,                 arm64_sonoma:  "192cdf2f0a9b8db682be83d3858e752a41731de4f7810cdad62f099f62f10f18"
    sha256 cellar: :any,                 arm64_ventura: "81143d5e60078b9de729c484903c1b2604e93eb5af4ebeef3b7a6723bf0a029b"
    sha256 cellar: :any,                 sonoma:        "f4d8d0656b4401a057f8dae81fea6da85d5d77258b6b3b708fcb0115b5ab807c"
    sha256 cellar: :any,                 ventura:       "0e7cdbbf36c7e9168ac61dc5a6a1ca0c0bcec5dd502a68a2025bbbe05f5f3c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c35b488589cc6b321b1abd2a6f118ff97134012866cac7d2357a2f6cb3c42ef2"
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
