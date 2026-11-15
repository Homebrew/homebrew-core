class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "c32d087d43f73094df9441cc77db11785cdd3e9064a105cb8f2dac5b10e474e6"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "49bd419751170b68f6ba09b473611d513b0a4a4d56fa6fc35e401feeb789927a"
    sha256 cellar: :any, arm64_tahoe:       "4fc8ee2a6830d59cec1afb678a40787b2bab12a86b4319f03dc57bfcc064eaa0"
    sha256 cellar: :any, arm64_sequoia:     "437b5d61f18fc074b13bfb99fa9b01fb7bac023c9abe957cc0770f70098c7b03"
    sha256 cellar: :any, arm64_linux:       "3bde7859a33f1867d0ad3c6c2501eca027ffbd6f0e331fbd31b0c3554adf4662"
    sha256 cellar: :any, x86_64_linux:      "1941fd5fc82e403e36bf502050c9fcb5a65362e6ee36429c64bc9b9216275099"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  def install
    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"

    bins = %w[
      cli
      keygen
      stake-accounts
      tokens
      validator
      watchtower
    ]
    bins_dcou = %w[
      ledger-tool
    ]
    (bins + bins_dcou).each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end

    generate_completions_from_executable(bin/"solana", "completion", shell_parameter_format: "--shell=")
    # `:pwsh` string is "pwsh" in the shell_parameter_format,
    # so we need to write the completion manually since solana expects "powershell"
    (pwsh_completion/"solana").write Utils.safe_popen_read({ "SHELL" => "pwsh" }, bin/"solana", "completion",
"--shell=powershell")
  end

  test do
    output = shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match "Generating a new keypair", output
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
