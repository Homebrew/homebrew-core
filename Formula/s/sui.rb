class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.30.3.tar.gz"
  sha256 "60b9eb2ac965a38689a30201e991720e925f5c7f9c1bdc6fc2a929bef80228de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60390eaad05b64c13eb05e8cc8d68eaf1d43e9d64bdf191f7590d1541cbbff18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4079f186e5a78d4e4b78f292d07cedbefb801a992fc3d4276f01c68e440f374e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4c52df12560b104b5fff1c192f276ebc2469f209a16513523dd66638588e4aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "28080ba1cc6a15879d63e32a0d368076a575eb886f320c522b27e1a56d04a805"
    sha256 cellar: :any_skip_relocation, ventura:        "af0cf1931cbbe1b7c9c6e5d7a7c2252d0f008d0d4f04751e3e3878d7232deaff"
    sha256 cellar: :any_skip_relocation, monterey:       "97ed893e8649cab7afe667dab683963d7d0505f3e807f2bd0d199b6c9b4388bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d46f529907120fb9aa80d389c350e37f455f174eaf328e8e68779e150a2584"
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
