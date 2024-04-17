class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.23.0.tar.gz"
  sha256 "fe9eced449e73550402e8e693d08694a80601dad8edfd5fd5a7827e91dff869b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0413376ecde1a0f740e600a22b56495be76af26e2cf21f6a1795681f51ea12e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcbc980c1852d40d47fba466474f771f291d093ad38c323b02646be1da93e82d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de2eb42884cbd0f1b508079fce96e4cab2efe946461e22652b624b1350abd585"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c5e32ea14c0b6291832070c343f7b909a1f06a4faa4c533db5ac14275eda3cf"
    sha256 cellar: :any_skip_relocation, ventura:        "67ed5ad81876d6e6df8545b466a0db3c5ae7a9d2f38ee4e8ae7449f6933b21f9"
    sha256 cellar: :any_skip_relocation, monterey:       "7ba8e89f8d335df28994c6baebf8ddbae07e4079196ba5cf6f4a519a3e0fb561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77c298b67daa277dc78b0a630d0a58eaed579e647e4a46ec84b5318f384445fd"
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
