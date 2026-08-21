class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.78.0.tar.gz"
  sha256 "d2683c5bcff6b3893fa98e18bfd3a9d30b312a037a535c94a89f9d0738e02040"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "391c0b41eb1a13adc24f4ef97ef713655edcb04ae28c2d756986d46aa599bdb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59ba6018238e42a09200bfc74fefed4a86e21aa0d4a00535a0ffca67d58011f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a80ae16e981294ee34c0ac5115cb3cca5739bf0713543bbcbf262f39640d66"
    sha256 cellar: :any_skip_relocation, sonoma:        "11724e480094aa2fd385e3debb3c76395b274647f1cb7173983f48257ef408e6"
    sha256 cellar: :any,                 arm64_linux:   "c79da960b8f9fd3c6b026bf0939f8e9186b7665f0f657491427dac85997ecdf3"
    sha256 cellar: :any,                 x86_64_linux:  "e76efbef95dd3234d80454c4e94336cbf0e62ae2691210370eafad48073f68a1"
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
