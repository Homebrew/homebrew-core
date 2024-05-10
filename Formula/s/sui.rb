class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.24.1.tar.gz"
  sha256 "a7e78849a86ed32c560fac41bf7c17189a8f174badfb62e5240a5e0f46682e59"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "166e172fa0cbf5562f14281c753737136d8985001b504eaac820db4fbacd2407"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19baff0117410e631cdc3e1e53fd4c19adf5f6ec674725ebc84a5850f0ad15a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b4361e26e6e0b4673dedf12972a6b1dbbd2e5e301dcd22c896a1e41fa11d1c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbac094148586830e06eab413c288ec377353b1b1a9a2e2aa51b537ab2f94312"
    sha256 cellar: :any_skip_relocation, ventura:        "53fb5f51b10df88c3dfb5f4a7dd1afa817d681bd19cd0bacefaa8f353a2cc786"
    sha256 cellar: :any_skip_relocation, monterey:       "dd1dd9c15a2b94207a6972ca9129e471c89614b345d964f89120d9f5eaadac17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d490f565765a84624e2307d12be5e9fa87cb7f92daaa3d0c765512dabf3b78"
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
