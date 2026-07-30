class Xfg < Formula
  desc "Sovereign private blockchain banking node suite"
  homepage "https://usexfg.org"
  url "https://github.com/usexfg/fuego-suite/archive/refs/tags/1.10.09.tar.gz"
  sha256 "e84861248de2a582cacd8a48fc8332fd38b9b9fee4b75263080a707bcc41eb5b"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "jsoncpp"
  depends_on "openssl@4"
  depends_on "secp256k1"

  conflicts_with "fuego"

  def install
    system "cmake", "-B", "build", "-DUSE_VENDORED_SECP256K1=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fuegod --print-genesis-tx 2>&1", 1)
    assert_match "GENESIS_COINBASE_TX_HEX", output
    assert_match "013c01ff0001", output
  end
end
