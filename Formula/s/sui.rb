class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.30.1.tar.gz"
  sha256 "b13430e4606c7d857ae09fa49558503f9118afe88357917f66ad4ff4f0ed8111"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb0a6aba04c4a1d40ac66ce92f6125018730aad2da12f9f0a7d718e2aae8cfa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60b8a898dca52b83624093dde0ca133853d79da791b4f1ccf573329cdc6c8c25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4b72ce97a36ca102a58ca67ce5ca41196deaf7e1b78c15bb73fc154d1e4ec23"
    sha256 cellar: :any_skip_relocation, sonoma:         "15097d395f9f14db963004db859be306d5a6e7243d0171c960c0ba025df96bca"
    sha256 cellar: :any_skip_relocation, ventura:        "76eb8c0b02ec3a5dd27e89e37604bbca46666a47325f8c280cb1a9e7a258ed03"
    sha256 cellar: :any_skip_relocation, monterey:       "c4fa06cc507e240a2de6dfd9eb77eb3bdced546be981e7f03410bcb8bd03afb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3f4a71142c0ffab205d17f4ff4fbc4a13189e99eb0956587a566a4b934bff64"
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
