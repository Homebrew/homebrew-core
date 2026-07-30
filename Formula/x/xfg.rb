class Xfg < Formula
  desc "Sovereign private blockchain banking node suite"
  homepage "https://usexfg.org"
  url "https://github.com/usexfg/xfg-core/releases/download/1.10.12/fuego-suite-1.10.12.tar.gz"
  sha256 "6c33c8d4460d90fa0a219dbec62d0b393150a9ac0e504eb6f2d99f6a156080b1"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "jsoncpp"
  depends_on "openssl@4"
  depends_on "secp256k1"

  def install
    system "cmake", "-B", "build", "-DUSE_VENDORED_SECP256K1=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd "tui" do
      system "go", "build", *std_go_args(output: bin/"fuego-tui")
    end

    cd "swapxfg" do
      system "go", "build", *std_go_args(output: bin/"swapxfg")
    end
  end

  test do
    output = shell_output("#{bin}/fuegod --print-genesis-tx 2>&1", 1)
    assert_match "GENESIS_COINBASE_TX_HEX", output
    assert_match "013c01ff0001", output
  end
end
