class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.21.0.tar.gz"
  sha256 "4545d2e8f63d329e5a954539ab38ece1a93ba99127323122dc27940c98484494"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb89ab3a53dcf7d4335c085feb1bc443b9435697a90858873dc21d346aa7aabf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4bdeb6e9bea76eb3140074e6280ecb7364a1d72dc09ae916dfb4b8901aa47af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce5fe9b1a87dfbfa9f190725459ca10a91f115a11b88ea60a1b4315c09f90f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "411d40a1e44454cda5c3416ebc6e9bc751ea70d8770946c028903d5f7bc32c1e"
    sha256 cellar: :any_skip_relocation, ventura:        "c714d89a82dbde3fcb7086feaae551d21c73b947ecac1aff21813f765be1c711"
    sha256 cellar: :any_skip_relocation, monterey:       "1ffadd122e7c78106cac4f8b17bc6920df6636007a4ac268a8b0d529c22aa7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4d9c0e366180b721fe3c4ea8b21d1db332cac380a1d5782489292b478a00a96"
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
