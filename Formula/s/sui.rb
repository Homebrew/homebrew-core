class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.74.0.tar.gz"
  sha256 "a67f6dad86bfae9d9736dc54799de9afc63b30397af7075f0c666cc958bb5901"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19697cc306bb88682c69e70c0591e5dcd70659acffb2022a71c106815773896b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e517c653fe2ed202fd4f98ebce16b26f084849112ac54c509b67f38b98f33ee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f540f07c21eb8d3700e663fc814d92bb0429fe385a92b58c0e89daf0d859c082"
    sha256 cellar: :any_skip_relocation, sonoma:        "280e995144ddb53090c00d34b1ca2ec7637d9399f79c985e4efe46350fcc65f4"
    sha256 cellar: :any,                 arm64_linux:   "fedb5031454e6b3dd7a6ef1790f34739c5cbc76a7204ec045e56d054049f7c3b"
    sha256 cellar: :any,                 x86_64_linux:  "e2f1b005030046c65f722a676830347eb1223d00e8494f894f2ebac05a8bb877"
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
