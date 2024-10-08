class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.35.0.tar.gz"
  sha256 "b376af922331bfb3028e123dceaad5f6af9480ebb5b201cd66475169044ecc01"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05d5399207c7b630fd806320647ec8ff2cdc3021dfa457b67c732c8ee2a03ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d0ccafd539b66a4cf41b37c808a26431969cdeb510c335ad28eabe7f0d8fe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37facecca329b4a00a838e7dbc89ea3259dd3309f283a8f658f4e2e9f6739b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8cacb5805c0b7f01a18cc650dc931cbe6b9970bb3b1fc208c1db02162e22026"
    sha256 cellar: :any_skip_relocation, ventura:       "3de2feaa1c1e837af9cefc6176c3481b3c8a7a79da2d76ad1037e35df3f3704c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b026446aac39bfb2e8a91863ab633b962c4fce0f9d3136918685824b99a2acb0"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
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
