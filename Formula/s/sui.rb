class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.82.2.tar.gz"
  sha256 "291c9078dc400cab30a81b707d9e8d8b2f0641bfe10712154c4a9ab16262a6ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1a469a45215cbdfaedb37c3b67705508678c55f7e09d23573a385818113217e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e7b57b1efd2ff6bdf6c59b40821c706958b708768d79e20e3dd99aa03a57dfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5de392b58e79817bca3684253ac2eba6041f8f23bc361483b4796ae0f6078e5b"
    sha256 cellar: :any,                 arm64_linux:       "d74ca0c47ee53f2e1943f70650b93d52fb34259e958455fa7620c1afecac925d"
    sha256 cellar: :any,                 x86_64_linux:      "8311dbc8bff047627f9c8ea3aa958b7c91f460b1554baa57d08fb96456b26d63"
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
