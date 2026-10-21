class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "e23ce28d4fbcbfdb1dfc2a6b5f8b4da2fbc3597d8a8c067d3914fca60227b395"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5eb0930385e119ddf31f720e248539ed797b405aa08dbb57c07b1d1cd47471f1"
    sha256 cellar: :any, arm64_tahoe:       "ce148e9b6748e17a077437005652bb725cb082499499e6e47144943c953ae02a"
    sha256 cellar: :any, arm64_sequoia:     "6284ab5e7c10b23af9864501bc8a5ebb59107e94cc49ab45c485c64ffa3bcb8e"
    sha256 cellar: :any, arm64_linux:       "3a717dd9277deee1f878f3a82b5b806a5dcb22f3cb0403cd1aba2b518e2883f1"
    sha256 cellar: :any, x86_64_linux:      "cc0380781e998be4770ad6748182ea75587784bdf08622c913fa1ec88fcaa174"
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
