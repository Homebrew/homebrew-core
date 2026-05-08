class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.71.1.tar.gz"
  sha256 "087de5a44bbb95228e1db1f985af5e793241882421d9edfe552f9a7b734d78cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "699596bfbe381bff63d29c7b261437c020321b3b1294f96e80e71590c531c445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76e3958691fb73682cb7c083422c77e6fa57a8d08f1a7dd2b3eb85ac926ece9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b0698a8c750b48d4f6921db8d8c9e02eb846a39073d87451ec1bab4b3f18117"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ba26619617b20b92c28f316b56fb238cacc2b6247873ab8cd65c7c315e6082"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6b989f93bcaf90e1bd8e3d95b2f157ef545c1947f69b93b9d8efd41fcfd3c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960f1c76d314ac85de4cdb23ac20f30ad508376e2fd286b6109add1040425189"
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
