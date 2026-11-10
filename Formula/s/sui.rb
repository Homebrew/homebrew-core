class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.84.0.tar.gz"
  sha256 "de92a4dc418dbb593f75b2814f8b503d83eada867fdb43961cbf5d98c2340682"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ce7d6e903db5055c97577b998fa4a9197a36fd4c5af48db52ede46fb6450944"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a98cfb718c17fa7d738f461adef121fb1b99e3744bc9bd07cfcade736b944414"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e6a6c2e4e0afc592dfeb9867b0f58b8df2f885021ecd11db2549b163bfce846"
    sha256 cellar: :any,                 arm64_linux:       "2ea5616f297b72d21a890056b05d20e7e1a4bea647a0babfdb489f111c5d46db"
    sha256 cellar: :any,                 x86_64_linux:      "e208876c7fe1dd161e6be743ea5098f0f26995742c2659f6a33071010a2767ca"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", *std_cargo_args(path: "crates/sui", features: "tracing")
    generate_completions_from_executable(bin/"sui", "completion", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
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
