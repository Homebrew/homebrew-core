class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.24.0.tar.gz"
  sha256 "b61016ee8a3649bbbe678685c8a78f2a93a7380516d2563d66bcdb0e9d176d9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81445eeee7c7d6fb5c098622e25823e52f0d1a90b5ed1d892184be0e8a4cdfdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "095e46d1a1f26f543687f3597ae33e1d7f5da8ea7796374576a939200c901b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aec515f2ea45bc80bde325eba3e458c4c366c4e7b7740151756005bfe7dd33e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e80a6fac84f95362422955254944cc8fc5e9b5aad905eaa428cb9d0aeffe9326"
    sha256 cellar: :any_skip_relocation, ventura:        "2f0603c25a6a29e818c8169b75b2f9a0b7570f22705547a61945ede904dd4c7d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c140f169b6f3ae115a00a5cdbfa95d4c716b14c42ca1131ba3fc327f56bb14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ef717eaab064e225186aceef6a5e0720aaa44fa2b5d005dfd4e8333791115b"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    (testpath/"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}/sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end
