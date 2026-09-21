class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "6ae81fb5657beb5fbe8c7bb83e6f0794a7a46c10a05c0a36bbb12e76579c7f50"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2223f68d96e8a239cb6436b0371c49f7847c5c08d414227a810f6ee563a41a5a"
    sha256 cellar: :any, arm64_tahoe:       "62244cd2fb837f8f9dbc20ae55060bf62d9694fc12ae76490387199ce687aeb7"
    sha256 cellar: :any, arm64_sequoia:     "673a46d16b1679fe7614f2bc003baf193720c93c11b3347842ca651ca5008fdd"
    sha256 cellar: :any, arm64_sonoma:      "02dac8996f475add5a67ca9aef97513410c7514c8d2a8691c52201643a98864d"
    sha256 cellar: :any, arm64_linux:       "5ed3103058aa54bb67f2c496e26e0cbd7f9cbbf75825075b66b881f6e7d3555c"
    sha256 cellar: :any, x86_64_linux:      "4f54b3ff35b6def23b49adbc72505a9adfe1f8af18ec74cb303b2b5a264fd122"
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
