class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "34294541cd5302b7a627db15362a3226cbaa282f6f6fec2845370f1e76dfa66d"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "34d7b849160fbb003f05d707218db78f423edfbf05e65506d911dcb4c3c80d93"
    sha256 cellar: :any, arm64_golden_gate: "9469e38716bd4752721489a220e5019100e3a1d6e72052d7908c38ed74acb038"
    sha256 cellar: :any, arm64_tahoe:       "854016e52a90d4025c84290417acdf327fcec928515ad0ed27a4325236297f57"
    sha256 cellar: :any, arm64_sequoia:     "c34c41320aa0b75ea446c77fba250d570b01f5f93480f7c82dfb45cced858f02"
    sha256 cellar: :any, arm64_linux:       "0f954b18734c78905dbb0927ddda03bcbb5bdb89cac37dc564eaf611d341875d"
    sha256 cellar: :any, x86_64_linux:      "369bbc65e9755d82d4bf1964435d015a64fc55a2a01152339e30838d94f559e2"
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
