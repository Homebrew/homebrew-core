class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "b950b857edd7c8bb1f629ce673cfdcf93a7a674f8d230a5d07374c250467c843"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f5b0a53fbcae5e219683291b89b30e7c6a0298deb9a62dc85255e5423ce6227f"
    sha256 cellar: :any, arm64_sequoia: "7442d3304db38b2bba9fc37975add6dbc681ea48043706ab899508a3a09e06fe"
    sha256 cellar: :any, arm64_sonoma:  "5fe2ddb98187914214c9981cca4df1144a6365390089c11db68e7dcfb00b641c"
    sha256 cellar: :any, sonoma:        "7f4661bc6c5b81a4d5090d74a4b1511ee3f374a0916f9531cd591a6a4444e913"
    sha256 cellar: :any, arm64_linux:   "7e3aac8e913322314143e3208748dc6588a3efd372d91e18b1ce38a0593da66c"
    sha256 cellar: :any, x86_64_linux:  "59cd893cbc9e3f62d12359d0140418a5ec882cf9912486a04974fabb3214ffad"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "rocksdb"

  uses_from_macos "bzip2"

  def install
    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"
    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")

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
