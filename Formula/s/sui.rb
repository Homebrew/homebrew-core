class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.57.2.tar.gz"
  sha256 "f810300c4b504e1331be1be38d9a9ba55a8cd0f56bfbb7bb19163cfd5846b03b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46d446c3d1dc8fbbbff51f26b9148326b48ff4dca3a1f02fbbedd794fb417bc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea5159e13a655cced1d6df14c65e6b5452395a5851457604b6583b5e9236823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6e6bb2c1f9a2a745a834841dae1849631dee28d27c1fdf91dad0867a42f3825"
    sha256 cellar: :any_skip_relocation, sonoma:        "169899b3da212e5bc73c7b5404a7a9e91256382df028f10c477687ff7809b436"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bdcfa81f043cde67bb1b2d04ed06f4ef638940aadcc107670905a3d7fe44df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f883e7906d01b8222219b219807e7186417de96fb594c32bb9830dfe076efd"
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
