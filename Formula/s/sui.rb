class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.80.0.tar.gz"
  sha256 "1d86468d6dd5d729bc591b89d6c2227b7572b44594e68ddb576ea654601dea90"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32eb6d38c4bc48c530b990dd3072669c64f946b6351c386ec90b3a41939d2a59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e61a03389004ee626d9148a0889141b6e4148a0c7d7c506c62ff61217ba3a95b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e583603fb92a77ac680d38d1cf90f675ec4be42eea98b4f8e460ba5fbcbf5f8b"
    sha256 cellar: :any,                 arm64_linux:       "e56d7453dd00b46057b07a613915874fab873709a127446e805137327461e574"
    sha256 cellar: :any,                 x86_64_linux:      "f76230cee4846059b5b25f2c4cd4ed86fd801567ff25018f50a1a7377cc03b60"
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
