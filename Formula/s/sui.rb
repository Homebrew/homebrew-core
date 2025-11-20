class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.61.1.tar.gz"
  sha256 "1d468b47ca33f053a5b27361a3cc7e2ff792a5ecc763434ebd1a744a54b171fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff1557ca2a09fe89311132c2cd8fb9d4f07a15ffc4f0eee96c37e83c0ee5bf0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5740c132dac6af019eb7d2d28d283fb8f7d8a7d6c7735098df820b7e66334f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f8fd1f34abe5ccc07ccbff01af4ea957ced8911d3c18242c54ac699a4e3e61"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d68bc55015ae1629c7acf3ce3667521e49b5a50bac35abd037c556fdc945cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeb899cb6feda95a777805b18d2b2ec86b30eb562c08e61d06e92713bdfaf0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b49a41c007bbd9e1f8b1bd001609441ae534f6ec9deb9bfbfced99178a42d7"
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
