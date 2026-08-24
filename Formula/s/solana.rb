class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "00740ce34e90d1ca4500e4f8029936f2101d328cd51926312286d049ce1a490b"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "49fbe4dcbfd34a434204b200ade816e1c700e91a543fbc28e587fe0eddd9a650"
    sha256 cellar: :any, arm64_sequoia: "de94f619fd8caf19fbf313e6f1f8b7b1bb020784e81a02dd71bbc465d49ee2d5"
    sha256 cellar: :any, arm64_sonoma:  "2965904a30f587140d1f1b6419d4a44dd3ea06c001b4f5e00f0d97244f4c5585"
    sha256 cellar: :any, sonoma:        "8dfbbec823fecc52e8d484c90364ee1ebda9fe55400d9c05079c7522012b8f06"
    sha256 cellar: :any, arm64_linux:   "88e265680f46e44ae2a6e6e440869cc15a90c58397c6117995a742ca0f5dced1"
    sha256 cellar: :any, x86_64_linux:  "b34610ef6de57c35f4c590ab587ccb00124427056843c8ffb29bdec313c34a79"
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
