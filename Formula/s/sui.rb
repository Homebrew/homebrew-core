class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.52.2.tar.gz"
  sha256 "4740d8cdf15b5dac7a4e5f3f6c20a823957526c6a63cf2b6c5cb4fdecd219f54"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8edc16441e0e731b5322fb892b9991c23a99f47fe734188719bccf55e49fecfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09740a4c93ec4e68cc2dee88c1d31a374105ea81d4115784b64d5160199fa61d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f79bf774875604b417b481c183aa8b6c7a4b1ff81f0680990fb3c4c7e223c231"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b17806c5d7ef7137d1f5c42002a3ba8206b5ba1299c2bebb5cdf4a60945ec4b"
    sha256 cellar: :any_skip_relocation, ventura:       "c20abe4d9c216200f73aba419198d85b8159599ac7341cca25df501bf191c690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "305d85bdeca6d8d33c35ed87a3a6706951aaaa1efd17751674a0a4ecf658ebcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49643cffcc5e895136aaa764f265a9344afd0bf318e25959fd3cb97e8d6888d6"
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
