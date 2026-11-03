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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d30e1ff6604ee69d97f3f7b771b4381adef28d0e154a30810bc11a4c5e857c3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31d71deaac42c04f6dfa5b37062769180f386b2dd227fe6d6cc3cdeab1927c72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c964e9fc519f0e1c018cdd5bf9d2180e0a260dadd51339c156ba63be1e128299"
    sha256 cellar: :any,                 arm64_linux:       "765eb407a358301eb6b284a0d013821fbd775b99ea36f06cfdc1a9314cd69458"
    sha256 cellar: :any,                 x86_64_linux:      "8dd79cc53162b04e3f10be3232a483e5ddd1a7176e49a6afc4fab149d7557dc2"
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
