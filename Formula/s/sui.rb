class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.84.1.tar.gz"
  sha256 "47d5a0b76f74681ab95beabc407802a1bd8e22b987e0cd8cc613cef98d077115"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76e8a5ef426df55c0abf6dd55ec29e5d9fa3c90606f92923e81c257763d4d2b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dcbaeb854ff0112f193040bc5421a1129493e68cc52e15122b85e7b83e7ea2cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6e39ac46c94a811f645d28913fa32344722f88c1bc8701c24858e537bde09bd"
    sha256 cellar: :any,                 arm64_linux:       "1dc13ffe275964cf092809d986cfbfb5d20063a5c55cdd9396853047e6a3cc8f"
    sha256 cellar: :any,                 x86_64_linux:      "e6ffba2f0da206de5ae2356b20b2416dac9dcc5919e604174d6b26bf9489a332"
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
