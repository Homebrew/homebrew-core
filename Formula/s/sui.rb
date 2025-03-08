class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.44.2.tar.gz"
  sha256 "ad295f121abe587faa84e8f674aeac091cb7b302b1666d00742ec76585448e23"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83be95ba82b0005c326b3ae7200a715f11ed6d861ea163c041a5b7e13dcbcdeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08f14c00db355105063626f2aebacf7eee660f1e3dc445ba5a95bd8a750fbe86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2997d132263bbcf92bc131535296fda60d78e5318f3099f817f273406bbf5b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "14458ac80a19c6e7ef4eb1e28651b40d296e3a32cde5a70f0ad644a3bcf9dd6b"
    sha256 cellar: :any_skip_relocation, ventura:       "16ce5f62bed9cfa97ef9ff8df379ff95bce98c533148a492a6fe07289ea42f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ebf8b2d9b611941b068956fd2bf0e3c20e98a2040160a3b5f3b2cf2c8b68d0"
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
