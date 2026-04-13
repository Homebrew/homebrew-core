class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v3.1.13.tar.gz"
  sha256 "02cf1eac551e0f04e41eb7f9802a1e4f34012f0ab31b74fa56eaf8df0db6cfac"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03122f7c98ed0d8053ef7a71a8dd0b1b4212cfc016da0f3d9fd7cad3990a0128"
    sha256 cellar: :any,                 arm64_sequoia: "3487a13d6002d69baade4051436d1a5ec65ba7e32f7539329cc42512205f6672"
    sha256 cellar: :any,                 arm64_sonoma:  "b48e83b80c04aebe7c8986f92c1f8c171b6d31c1dced519e70838ba84734dc23"
    sha256 cellar: :any,                 sonoma:        "f1e7cd96f7ef78ffac016e45ed2d245f53e08fcaf550045883ec5f0d2debe18f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14d2f94f76c0c07cfe295cd035e529e823fcbcca843c8c033c352c94bb786655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d935cf2a8a7ecafe44df7b6ac9ce5e06cf10fd5d0f7f8ca9f23b9f90dd954a7"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "rocksdb"

  uses_from_macos "bzip2"

  # Backport fixes for newer Rust
  patch do
    url "https://github.com/anza-xyz/agave/commit/8f3944b2159112b8e017b41f9c834344b32a7c59.patch?full_index=1"
    sha256 "b5c59105fd9fa22f96a5135d3c14a61f63cbd86b31f509a06574965520c11414"
  end

  # Backport disabling LTO to compile with Apple Clang
  patch do
    url "https://github.com/anza-xyz/agave/commit/5e900421520a10933642d5e9a21e191a70f9b125.patch?full_index=1"
    sha256 "5a03a89dfcb91a3b579e1f67a78580f626c6560e8c6a46c371d7297665b22360"
  end

  # Work around Homebrew-specific issue using Apple Clang 1700 (LLVM 19) by updating cc-rs
  # https://github.com/Homebrew/brew/issues/21112
  patch :DATA

  def install
    # Work around until new release as fixed upstream but commits do not cleanly apply
    ENV.append_to_rustflags "--allow unused-imports --allow unused_unsafe"

    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = Formula["protobuf"].opt_bin/"protoc"
    ENV["ROCKSDB_LIB_DIR"] = Formula["rocksdb"].opt_lib

    bins = %w[
      cli
      faucet
      genesis
      gossip
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

    generate_completions_from_executable(bin/"solana", "completion", shell_parameter_format: "--shell=",
                                                                     shells:                 [:bash, :zsh, :fish])
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

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 045adc06b4..5ffbb89f1c 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1720,9 +1720,9 @@ checksum = "37b2a672a2cb129a2e41c10b1224bb368f9f37a2b16b612598138befd7b37eb5"
 
 [[package]]
 name = "cc"
-version = "1.2.16"
+version = "1.2.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "be714c154be609ec7f5dad223a33bf1482fff90472de28f7362806e6d4832b8c"
+checksum = "8691782945451c1c383942c4874dbe63814f61cb57ef773cda2972682b7bb3c0"
 dependencies = [
  "jobserver",
  "libc",
