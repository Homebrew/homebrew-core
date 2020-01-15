class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 7

  bottle do
    sha256 "5372da4e34c78512fe8cfe9ffe5e64e652a1c1654ff70bb97c795a1774796e83" => :catalina
    sha256 "43e526458be2c9189e44c93dee0ff52db0be456bd875cd23d2f13af96cd39974" => :mojave
    sha256 "8178522a03bc22c0b82e5c2f2f47a5744a35c21f747534c883a45bec1b216a87" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "ilmbase"
  depends_on "libraw"

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Day-light (e.g., D60, D6025)", shell_output("#{bin}/rawtoaces --valid-illums").strip
  end
end
