class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.50.1.tar.gz"
  sha256 "c1447436f307fa90f7e1ed73f009c2bbb2a303dd39e58d5d4ae4713f0a2635ea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "993b9876c14650fb6c5049da97f365ce53d109595f286bebe2475ea0cc10ecf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51908daca2a819377163e5c91c7c3d5b11c5f53e87fbfb47abe806485c22798f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b9a30e8dcd0a0e4a8068768e24027e793a937040f14a164f5be61e214a9de97"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd2cf2469f20f539629655812650cfa869d96e116e0b9c354b0f6b9ec1c44d97"
    sha256 cellar: :any_skip_relocation, ventura:       "46df3a89746faac3f0c437c0f3858265a40937689856f5d7fc7de03a1f0e5434"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c802c60c1a4cfc8058dde7b292de910bdd4ef8f5f36306440fa64a0af77798fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ccb07046fafa7f3c64a4ad1f51fa1f692d498721c4e0e1b21f6c25982f54bfb"
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
