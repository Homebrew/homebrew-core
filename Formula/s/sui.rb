class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.47.0.tar.gz"
  sha256 "bb704e9c333f16a9f6bf85509db43dcd72b0934f6f0b0867aeec2b472f247b40"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a4fe243cb04f9ef11b8b0b1c0584f44890ed1e6cff5a7a9af4c9ab1b2f60f52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a332558dd8096f154a00859f61ceecd7caa1715a4e00952e28dd9ae9deda7cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5888112a0771e7382a4a08d8ecc67119a976aa95433ae7a5ea2944c7efb72e68"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1eec34532b6463a7e4316cae4df7679943cfaac5e78ba6e83ad8672fae2ca1"
    sha256 cellar: :any_skip_relocation, ventura:       "302d453e0c90cf0b0d84b6a099cff645c250fec03864600d871589f940f213d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "967a208712fddc04b0f3cf41dfc06eb86a76bad8889ca4e992de22cad30f0a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a334088408a8afeca15878ea6b50bc4f81eadfed99d8e93836eb8fba29c0b50c"
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
