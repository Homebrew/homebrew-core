class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.83.1.tar.gz"
  sha256 "ae83ad75d169d39b50e5a88bf22c41bbe07e5cf42dc93dfe49aa2d9cc8610bb3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60802a7f014a4f89b7c879f4e201fedce1cde65c2956005fd8e4df9969f31157"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9801080da5a1eb3315d69d8abb1b98f8cdfaf875ab06b77f8fcc307cdcefe6a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08687f2a56acf78b1632e6c5b638064e5abc580ac9b47bb045b2599bfe3b7f0a"
    sha256 cellar: :any,                 arm64_linux:       "1e19132e183af8e08c9afe773763ae696ee3df7445c4ec1e78b39f8cc9eb23ae"
    sha256 cellar: :any,                 x86_64_linux:      "be1f529b5caf1154bfbe86e958d08287fdd14a390e3f23125417dee9cd58635d"
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
