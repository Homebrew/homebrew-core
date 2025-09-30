class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.57.0.tar.gz"
  sha256 "697b0e78d1c77f898896d58c6c78ff88d90215fc9cb974bbbf0c768151fb4d53"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d1c58fcd32fe02df8226c6982e3269ce7970989e85d31bcc75c69dae9ff2dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "846b20d6b0de518dd5c4a748d6ae4082478962fe871fcf2c6db7f4ff09c75fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e73a3b74eaa8e157ca2922322b0cbf7b3f4ff9d2d59264d7c0074e54d95416df"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d3c7a4b1f6d8a872e0d49243bd087ee049f42f7dcf8c259bd5086b3d9e1ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce65ffd22cb4ffbb86a9aff96d1990d894f0821c9fe32850778a81767a15770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebcefe6ef671de3c68c1df02ae9d6b460af222e4346d71d54d925bf3475dbdbd"
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
