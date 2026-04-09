class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.69.2.tar.gz"
  sha256 "046c3b823e7041847841d3f74f10aec84d7a8c73287da4a862b4a969d13b63ef"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c38d036fb7295ddfe0bd8b93c3b2cc5a81d4309c6c46a1f51df17cd9ff72b27f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "073d51d35472ace15e9d31dd70764d315f81d53935be505c277ac4a1998b6078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c56d28e85fca32c76b99e85676fc1f640ab8152dd3b47df18019a04d6d21c445"
    sha256 cellar: :any_skip_relocation, sonoma:        "cffcb2c42801e44c2d6cc0526b9dfc01f45fcb06ff49d36900f8cecc4a24a8b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9411f8a916f94f5a06f268ced7ab32e7ef5ef1c5db30feb2f78bd4b5172d6757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "521f8b50d121cb4a6c954781c468ffd65b347cc19d9a2762d3d450b2962b8e8a"
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
