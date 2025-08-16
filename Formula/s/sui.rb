class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.54.0.tar.gz"
  sha256 "90f1fbe41ce19e3b68628cfa69e3c58828988ba4420c0fcf8f2c956edba445f4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9babacc69b9442195776cb8a4c9e3c9c2c3bbe1ff3ced05a1c84c31f6726eaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a3c57f24caba2f724617a7781c4e48277d0f483ad2d14f8b9842e477791144"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b937ae42005ba84f671a92fe8feba77716160606efcef6993ff6a2900b82a6d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "74187910ae73a43fa2ecf6d982ec0f59bd4a6005f1f0692aa1e5061c826472ec"
    sha256 cellar: :any_skip_relocation, ventura:       "ac8ac779f84c64c8e71c646b8ae4eca2ed405bd7ec0171b76ccb6eea61f9b180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d37dd9dac6b679449e7da4a058d1d9ccff2380f1558a52551d83353b3c90be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b331c0730384c446c7e425451625c720e144a98190ee9caa10132283e2714b30"
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
