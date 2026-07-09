class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.75.1.tar.gz"
  sha256 "6061ea2c697a7790e90986f375f42cea43d5967a7140d215b9ad309b60c0299e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6568e7e19dc668ce042cef7cc5dec54e4eab4371851761e48f5662b271d26f2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bee36cf93406a28e9eb2d7e44420c2a6ed8a6f15b0107c3ef4a39a85775eb7c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7f7132a518123238a8f76bf843d43fc44e661d154edfafbc05d91a9568da20e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5278f0dad3f8f8f55643e37f3ba2a81e6adad575ec27a85117ba42b7abce7ac2"
    sha256 cellar: :any,                 arm64_linux:   "4f453336cfa34850e597a659bb66dd90b6e7beef07d6ea6e8343404376590bc0"
    sha256 cellar: :any,                 x86_64_linux:  "63df093a1ab2ed48b1281450b3c4bdd2793b3a87203c784487ec286d98125f41"
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
