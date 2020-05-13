class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 9

  bottle do
    sha256 "0607222bd4bf6bce0928a654d019bb43a64e2c858246e5ff696a2ccdeb39e046" => :catalina
    sha256 "9a23404887ca9a6655be8bd8aeaa8cb42552bcdc90e964baff3e95168a9d4f63" => :mojave
    sha256 "ae2981d11430b7f54d25f4a5add70af39816d01969dd6120f65cbca503bf957f" => :high_sierra
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
