class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "79c2b54a71fc0e794afe9ecd43c5c506c07368743b2b0d073cea65a1b9eb072e"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0f140bfba1ddc8a13ab819c41ad2b39d55b2fe0567f0417f4068413265842f5"
    sha256 cellar: :any, arm64_sequoia: "74fc844ee6c0337f9065c0822ba739d20a801d7d48748fd12ef8459995897fe5"
    sha256 cellar: :any, arm64_sonoma:  "30e177a298327267a393711dbb470e95cfc6b3d241548243317f47879c77bc54"
    sha256 cellar: :any, sonoma:        "36fa7ba2a886907a85a2bca13a4785b028942b1ddbce29b393f8054eefdcee02"
    sha256 cellar: :any, arm64_linux:   "b6ccd4da30d399899603fd3c2bb9c2e2f155b0bd5a4de9af2ab151e3870b88d7"
    sha256 cellar: :any, x86_64_linux:  "be0985356336b544c5274df4c539cc680729d7eb78162f1ea36598208f2b5801"
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
