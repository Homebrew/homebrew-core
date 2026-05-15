class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.72.1.tar.gz"
  sha256 "9e7b565e7f2178f4d72393eb5e2200dcd0c2c2ed89bd024b783bb9ec08517d71"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02859b2e959c389b083fdf14fd8e21dceb640049c8cb91f1a707809f172be64b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eebbb9b626714e43ffa459cab169783f891a1e4bf5348b7fb2850ada6a24483c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5550fe2718d4284d6813345722b4e0c4ddf2db46b32549b993958e41870d5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c645eaa8b4664588e07723d3a10b70ab569b9d96596b32234e19c2ff8c9156a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a76884a785f4fc7f6a3893ce6f02bf36ecf3bcc40145550c720273b929968519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0844e2f80b98bfd67795b29eb300e1de91e75bc7781955a4c208dcfb991f4c8"
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
