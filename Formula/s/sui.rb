class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.35.1.tar.gz"
  sha256 "37b5d90d9e17f5b146162d8ad2646eb6d561b6db268f28fc3c00677164cc9d5e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89705e6da9223e2c40d61e83f6bb78525017a1a289a45fd7e3b305eeb91f98a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d6bc47fab6fab6fcddac45c4244d4cd9595daed96cf2a20b172c184205f6704"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b76d1400f7ec555a1fb83bc1c5ea35ef172fe5efdf0610bd13f6aa40d44664a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9aed78bbe08ce516dfa019850da83d8944d326b8416f9121dd25a31f3bc6c91"
    sha256 cellar: :any_skip_relocation, ventura:       "4fc65c66590d0a20f2353b10f88edd9b0d9f76f7f1ac4fa2eabbc5810e543127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6a5ee8f3f755be87120e772fd55c67cfa710efe1e7b7d2f3c1fbb233722762"
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
