class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 3

  bottle do
    sha256 "dbec8fadfef3656f1a50dc294d29108897915cec45e30a574e1ead0495d09feb" => :high_sierra
    sha256 "18c4e2160f8725e09d322cee8baa83deb37c6f3c5cbedc134bb9e5bc92560598" => :sierra
    sha256 "b99331ecc201f55c81ba188f5d2be3e1c12fc7c5157eccbb56e8eb5a1866c92c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "ilmbase"
  depends_on "libraw"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Day-light (e.g., D60, D6025)", shell_output("#{bin}/rawtoaces --valid-illums").strip
  end
end
