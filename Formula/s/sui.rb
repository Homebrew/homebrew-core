class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.76.0.tar.gz"
  sha256 "58bd9d4722b881f5e5152f17de64002f0b4c872226469f3b291005c796514f17"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43d0458c0e1c94e054c355a91b8b6bfb018b8c8a9e2a269cb8b2952d7b39fbf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ea923af333fe526118cd3e244bc24013b67bbc18ae279af973e596ce691121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70fbc50376a1f5df2fd4ead0d33965ffbe4b78db814312a8f7d55b12a4ecbe8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9288a814659f3dc5d5fb0e8937db5493bdeb628f52792c48097e20c59feb2fe"
    sha256 cellar: :any,                 arm64_linux:   "7ebb4f96ec06df6c52320fcdd888de4a65160c12d11c6456f5389e6dd3f49047"
    sha256 cellar: :any,                 x86_64_linux:  "62a51dddda9de1cfc432bccb9ac9a172e40fdde48e148a7074022dbabaa56b88"
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
