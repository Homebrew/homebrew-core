class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.46.2.tar.gz"
  sha256 "3d5fab2deff62bec7de0d563b77f087e71a799d2c4e1a14ad56625bc00e54107"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b815dc1428161f6b6f9f8979760993a2e1fbb304863d3b3a0c4fcbc41b795ef4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15678c11d7b451919293b47bef3eeb0a31dd47201e718c421b3a02e1c3f3870e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "820fcb9e165d7d2ee3421eb71f35702549b0718cd7c0646f347f8eacf455cd2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "841c807bbf2955d0b3859cc5e5ac8b26cc6460906750ffe1707d23511a5bf1b2"
    sha256 cellar: :any_skip_relocation, ventura:       "56504755c006ba0e87b08100b975b1e866ea3d1c1fb4fd9100a51d83efc20043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85ddb3619c92c817715706404097479180b092012f81724f0ae8a12b63a36be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f3811ee4cbd3da532f7118db22a175224c3764e53460b0a356e38aa01af9b0"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "crates/sui")
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
