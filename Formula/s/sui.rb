class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.19.0.tar.gz"
  sha256 "f584d8cd9bf4f92c226c28463585d1898393426e54e17d90335ee31d72495f8b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15b28d97c885f41be47528ce0abe26cf62d666292e727a391cde4dd7668e0a87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ce56abb1e99c0d8ba9eb3d520d7a723a2935ac70314244874ba84150ec0a1ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f85153d54f2cce2d4c39062c72ee24734d4d094d576b0a960e45b5ee793c5b5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "91cbac04a1f2524923b6af893b6771c119147d27be844362537d1ac0150ac5c5"
    sha256 cellar: :any_skip_relocation, ventura:        "875110d309b1f6a90a939c9eb6a34869a7839ba883a4220b9985fbca88aed270"
    sha256 cellar: :any_skip_relocation, monterey:       "bada32cacc471ca0c25f2dd5ce0052dcb6c29503838ee110ff4ebbcd969e7c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c40ca7f515945354d4e527c8216c160115e29425a7109a16869795847d28d1a"
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
