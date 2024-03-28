class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.21.1.tar.gz"
  sha256 "af9e4136a362689f4d9089d18dd7659c76a41ab6d7a203deca7588a1a47bb159"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eee0d5cf44d73d450eab71806eeb5857265d666146beaf26d60d07058c7f431e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ce33368f68904c2ff5c6d21315147e3991da0c5955eb79b55ccd1a0e265c57d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4079ff919512e80f200985473803533e37991579217bb7d9ac8ab862cd3ef882"
    sha256 cellar: :any_skip_relocation, sonoma:         "eac1545d66d451baaf26736ee755a5ac32f6e227a886de6611deddf3aa3d4362"
    sha256 cellar: :any_skip_relocation, ventura:        "9b21807996c3f31fc9d72510df1acc37ebd94d0fce13c57b712b2a3c098aa211"
    sha256 cellar: :any_skip_relocation, monterey:       "b744a5cd0e6bedd7348085d31b35abe8c9d32418f53e7a1c27b5ce968227f384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bee1c17f6d810949351d7a836f5bb01fde23f92e4a86ebfc294a497f964ac79"
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
