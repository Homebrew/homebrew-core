class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.42.1.tar.gz"
  sha256 "57c704ec80dcc61a2ab1360945b24827458074b96a078ae93e3c6f8c345142b8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b6eef27c454dc79fc73d1869aa14f87755827fda1429d746a2014dac74c6c03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c030b2f7428a99d6824e80dab671543647d8c6c712923bd1fc429b9f46364a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a8bc29302ba26b899fd2e51941acf76af5af8dd4326a0603d3929013fecdf03"
    sha256 cellar: :any_skip_relocation, sonoma:        "03706222b51d13bf7d879f91f18609aa8cda7a3e60e06a75165f7abbbe28a77e"
    sha256 cellar: :any_skip_relocation, ventura:       "2c73798b9756e4c2897f073e176f9e617e0851feebae9539ccd516b1b04237d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef5f072bfd3985137a789fe012e6f46a71caff84f4ddcb4277eafd3066997fc"
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
