class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.85.1.tar.gz"
  sha256 "c74cd9eeb8f9206a70feaea3f1ad8f5b4de33d0b894e6d43396eef11d36b950d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "800cb0baf568685339d83420132fc7ba8555fbb6983c22c7d8dd1b3636159c07"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff07839e15e580c23e25c1118276806b4a59f6262842403c592977560ff7f796"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e3f39a699b0f4c44be6f4e011e9ce5e51753b3de343cbc6cc1b41964303d51a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3170a12f715ca9c5a7354b7809ddf0dfe0f06634ad2d76f70d52a9d9c05b8131"
    sha256 cellar: :any,                 arm64_linux:       "37933b4c0b08c57eb46dd3e4ea1282ee7f58b0a41d8b154b270d2a8895d5ca9f"
    sha256 cellar: :any,                 x86_64_linux:      "c27d6ee0f366512bc315902cb8ff18d1bf78823be4d39b1ad5fe640de7bee87f"
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
