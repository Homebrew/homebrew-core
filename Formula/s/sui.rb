class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.70.2.tar.gz"
  sha256 "3fc7537752db50f5727e751aaa0443863476449a6019b87f94d244680b7c5640"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a847d3845dee824fbe46da9763898cb87aaf2cf32f97a3888f5c55b38585f2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6095f8b08a503e22b01f889c09cb2e73d363e988260070288c797a21c597b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857626463e37439597e0b179f233e6522c4c988d8bf7c9d8012109216eee8b94"
    sha256 cellar: :any_skip_relocation, sonoma:        "649fe6b90001064bd6d38b93f1be37a1d8dc5346efcf60bcb2c1245152da2868"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5bef851860f8264b16bd18dfc3a5e95ac1ba271cfec85a3c18bf40ac6bda19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ff2a3bb17c5296c421caeb9472a6c264d8c750017d614af0a2e51ca8865520"
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
