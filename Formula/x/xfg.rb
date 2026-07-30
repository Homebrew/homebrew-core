class Xfg < Formula
  desc "Sovereign private blockchain banking node suite"
  homepage "https://usexfg.org"
  url "https://github.com/usexfg/fuego-suite/archive/refs/tags/1.10.07.tar.gz"
  sha256 "dbc87c3a8ba2f4f526bb2c65686375b125791b307bca6c8878d22f95973726e4"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "jsoncpp"
  depends_on "openssl@4"

  conflicts_with "fuego"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    cd "tui" do
      system "go", "build", *std_go_args(output: bin/"fuego-tui"), "."
    end
    cd "swapxfg" do
      system "go", "build", *std_go_args(output: bin/"swapxfg"), "."
    end
  end

  test do
    output = shell_output("#{bin}/fuegod --print-genesis-tx 2>&1")
    assert_match "GENESIS_COINBASE_TX_HEX", output
    assert_match "013c01ff0001", output
  end
end
