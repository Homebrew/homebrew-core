class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.61.2.tar.gz"
  sha256 "c79f7b90129004d1ffa0a372163a67d6cd3694fdceace2769136f35f236f91ee"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "124a4d97be9c1ca7f002b3f33342c52138023a464497caa8db7fdcc366405417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ee2d89e22a678197bd07de29ea2d94d6f0aa28eac67d31ba6d6f33e61d04aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "520e6e1ff786780f5924d781dd80ea93da7b299d99932f566093682d35223192"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ace41fd199a66744ff470b4034d0d28535e79d14d60d4c390fb2d6449bbd8d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c84b9bf31f201d62382b0822ecfd678c9eea4f17f610c86cc6587df2e416ce95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80451bbf6cd6da2f44a5b1fb185b0be06c56774eeb1a5ad999f95831b4a9e359"
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
