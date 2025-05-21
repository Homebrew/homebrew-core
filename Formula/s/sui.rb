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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5caf392a0d700c55a36dc8534dbc5b9c14e6fadb433b240963dfff4d7e5d562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "619a9010bde5eaa02c19e2f4f529881d50e9a70fe0d25b01bea2c656594ee25d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad37b1d600245c42953343bb7a20e9fba6d42682f409184dda90e206582f9580"
    sha256 cellar: :any_skip_relocation, sonoma:        "68d7e2d195663ee65f048406a2f178940ff2e354f9d5a411d3dfcb5b6ae5bf71"
    sha256 cellar: :any_skip_relocation, ventura:       "fd2652aab665b40e46250a92e49dad9eb5844dd8fce098ddfeb7962d6c46ee5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2d45fad24a581014274dfde1ee2a98b377f7c1cbf666df602c5eefeba4edd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18cf24c9bcb085cce2f015f16c61615fadebabf56c29efddb1880714e760884b"
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
