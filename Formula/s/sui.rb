class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.63.2.tar.gz"
  sha256 "38c3550153739486ba1500811a26cf3bdcbeaba90e12982078d838d64fe6c8d0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "561e136b20d6a504f536ab004f3e40f8ed7d97b4980d26e9d19873fdbe32076c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e4fd28d2efca50af9c6ebadab00fe1b15a9725adfa010e92d725a00f07df515"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f713d78a5de749e0a44098173dc1f8ef7fdb198f97981b448accfe363225d7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d77132f60b8eac26929c7f09df14348219055208568173ca86b270570b7224c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9eee5b5fe5b673b75915ac95144f93e6be8eec714be1c6524d8dd028c137d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268145d281e2602c2cc0e6ea5134227a200645389114fa397c691826707280a5"
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
