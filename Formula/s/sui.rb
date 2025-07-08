class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.51.4.tar.gz"
  sha256 "351a3c8a3497b85630a954565d61d0bd16d379aeeb51a2621c5605d6e2be8290"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f7c063a9ed53695dacdee8b501c3418b67f1b7bf14865e107a0e1b67595d745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5bc64116b3430cd75c4f29686e9b38d8f593c277a39a2b93c8f230d366ae32f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bc9b62842c079c1558879fd9e55854690b27c1d2e389b298c0d3fe4349b0f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c13f8a6b711251c8523253855a2af9b5ba84834613afcd71ed471bc558c39ba"
    sha256 cellar: :any_skip_relocation, ventura:       "d0441af50c27b18d009c931e57c07740b0daa70adc9438b1f6e25a24f879b057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d3d8367771ac238fef67cd634c155f4a6d548a670a3f61eee377860aed82137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cae9c2834f0f089efbb3c9b8f9061bee8684f9ae837588443104275b107ddab6"
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
