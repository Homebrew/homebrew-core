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
    sha256 cellar: :any, arm64_golden_gate: "1324a806e0f42a46474c6604bdf78df6d0dfda74ab836718f8ea54f5caac2582"
    sha256 cellar: :any, arm64_tahoe:       "e89666534a0d0bd0d7478d3beeb0b1d1273e470a8ed2bb94a21710106383724c"
    sha256 cellar: :any, arm64_sequoia:     "317eebf19b7a2a2f51d31090d265ea6660536294af1c2520b059e574bf8f4ddd"
    sha256 cellar: :any, arm64_linux:       "1acfcee594c24c21891771c7b3ec4bfab32fb0717b173398782e2f6527e19777"
    sha256 cellar: :any, x86_64_linux:      "ebda0e7182a35d9390f7915f3a27e41fcd22a413ecb076e8b0f6fb90b20ab12f"
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
