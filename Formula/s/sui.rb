class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.49.1.tar.gz"
  sha256 "32bd133a638d8bb3cb946827ad0c526ef7fd12684f114ee5fd4e9008158e6bd5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "254a0894d73bb8333403e32f220b422a9f08b9235296dc6aca3dc8529a1a94f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "204cc101850bf9b2ee893df33b4349a14b6795cca07eca0bed0539dc9c7100eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a64612eb515ce62fc393160f44f8d58fb391f4c45ff56d5e724d7c72ae389b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "d91eea4614bef120daedbd7495d1669392b1189437766ab38bb7fa480643d3e8"
    sha256 cellar: :any_skip_relocation, ventura:       "2a68fa2a2d30879096b4e7bfebeab65fe13df35b1d7ad4871f692095f4cc0f50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b389845e2db454c3eaa7fdc382bc391c06d9ed42d65075b3ce5fbb610343f50b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c86e9abd3477fa7e3f1ef6322668bdf0bf3582bcb8bc204c764b97ad1d3d551"
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
