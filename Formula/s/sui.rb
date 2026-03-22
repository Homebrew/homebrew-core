class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.68.0.tar.gz"
  sha256 "16627bc6f65669b77ab590dcedca138661b90979ae55543c6a0d2ad53a4d4528"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06ef4970153854ecd5b230f9f1f94b1bc27a3e7eff1800a3be9666203a5bd2f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2ac19f3e38121cd9e3376c17f43ba28e238b413083710eb5da2a6db76674d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc3185da8df0696be1e75a70f5dee4e3277f449e3f7f2c7760fe52b002648f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "12f3a8370f55be6958da4d6cfaf382ec398118cc6b0cd7a67ef8d0c4f56b6938"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b7a44168f2c63321e0579518b11b46124940347e82efdcc87113742269ee958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee13bc6986b714dba1f0d4bf663925608e29004bc1a2101ba9601e27b0563a9"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", *std_cargo_args(path: "crates/sui", features: "tracing")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    ENV["SUI_CONFIG_DIR"] = testpath

    (testpath/"testing.keystore").write <<~JSON
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    JSON
    (testpath/"client.yaml").write <<~YAML
      ---
      keystore:
        File: "#{testpath}/testing.keystore"
      external_keys: ~
      envs: []
      active_env: ~
      active_address: ~
    YAML

    keystore_output = shell_output("#{bin}/sui keytool list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end
