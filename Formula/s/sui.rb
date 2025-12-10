class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.62.0.tar.gz"
  sha256 "91077968de1c7567526d494c15522e24b6830b4cb0323f3ca1b12202e19c7a6f"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce928ec3cd87bbf87cb00846fc8e896eb10f3ebfd0c10644a53fff60dd4199d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f0bfe86ce717de14115771e53151c92b33d9ab2bd97cd64e555fe9b59bd0951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fee15f2b141021727e2017efb2b3ce42cbf045a3870a294d1a239c5aec816e34"
    sha256 cellar: :any_skip_relocation, sonoma:        "68813e3284d8f4d74affbefef31e9d87d0341771e23d9b6803c143bea1d1ac93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd956bf2f16e079435e8df126e129ea56bdad281e999671541311470a8c00af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee01063e1210cd17783c5ec74bcfd1fd2bf669334bd4bdcd61ef5f65df9dfc3d"
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
