class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 3

  bottle do
    sha256 "35b1c3038fc3ac5f2afa237a02b0de3215fd0b5fd6ddc98e4efda984e2f8cf31" => :mojave
    sha256 "2dc85c4d307896a2db9e4ed9458f4f9c002d75d1799969c9b81f1d6ccfb8eb99" => :high_sierra
    sha256 "59cc3b6b51f62226c3de9329a336789401ab060126d5bc7d11aebc666acdeb1d" => :sierra
    sha256 "a6f274bcb805bca7ba760d7c194d82bca3b900f4b4196e317f240737ce59f015" => :el_capitan
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
