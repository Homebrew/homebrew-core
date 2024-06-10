class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.26.1.tar.gz"
  sha256 "647942279eb7b9270fd98786924faf60614489f88493fae56a49a650148d5838"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9435a4023572f9676f5452a20a7878c48ae2a287a59e88d2acad3466b1195294"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0420ea41ac93089c675a1aee81b624ed4d0e3644ba2b2ea4b52485a05ef01f81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a58b6297f605da09f2dd9808047f7e6eeb1122cd6a7bdf46f87ef2ea9f8ce66"
    sha256 cellar: :any_skip_relocation, sonoma:         "849f6d5241ea692a0208c45e1c513d596dd2bc25a65e10cb360209553f8fb12a"
    sha256 cellar: :any_skip_relocation, ventura:        "2d6eb16db940087ac7115574598bb905813f14478eae5163901598226b3eaf8b"
    sha256 cellar: :any_skip_relocation, monterey:       "134ebed4953db3d6c2d0161e6b5bcb0c06b45f27fccf607366e8869afc752069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f618dc4d6190cee4858e7f5563265b0612b520473410611753d694fd58198651"
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
