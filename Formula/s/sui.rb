class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.33.1.tar.gz"
  sha256 "f2e3264ca9f09405b91f1c2720a94ea061fecaadfc7907891a96d277044767dd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ad669813be72dad4077fa33ef6dd28164198b31ea9dc28f07c0909df5cfa57e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f871ead96d02fee6aaf2bfa9c4e82db55b49ee0261f5514256e6321b45be42f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d1f62a5d57f682e3a8ed79487299054de3be77f5fac33e6c8e7760a349fc850"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d48afc8c1a33a0c748af41932d6ce85beb6152f7cb4cdb65f47b89e6a5d94da"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a83210546d0c9bfb13321ce85d20e39fc3461246bda0af516814c9506584c78"
    sha256 cellar: :any_skip_relocation, ventura:        "eccc19376b8e6045b8670b24f69e81c66dba3c5852411478b7025317aeff4fe6"
    sha256 cellar: :any_skip_relocation, monterey:       "13d26a8e4963c6acb8a4529c6da8736a89a2a3c985cc64f8d324209a702690d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "770b8accdddae7a319febccd2361641bed3d4eded1bd881398838b780cd64187"
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
