class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.73.0.tar.gz"
  sha256 "0991efdd116a222e2e509d75e27156ce190e5b3a02351b20dab2db751a3e5d35"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "748e7b213ca05fbaa23881d8ca28dbddd18307cb0c3c85b19dcd082637416513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dcfbc8a7307ce8978730bab5156b5091957a5233448abafacf2691db8d7a06c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76578e285bb6ee8c13406befc675bd2b17a03d54b827a781cade06b4f07c1c21"
    sha256 cellar: :any_skip_relocation, sonoma:        "2589abe3674b4079db12aa31901d83d4ea37693b1df641ef49375a14a7d57db0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70ca5651ebd223de9a8ead6178da0614f501a7a127da39fb47673b9b9ecae0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4088cd9c49c41bb89e276182c3d6683622e240d60417ced60b6130f411006c06"
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
