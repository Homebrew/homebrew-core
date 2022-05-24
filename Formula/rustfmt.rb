class Rustfmt < Formula
  desc "Format Rust code"
  homepage "https://rust-lang.github.io/rustfmt/"
  url "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.4.38.tar.gz"
  sha256 "4856cac540a6d894bc019285b690cebd2076aa8067bd8509ec176645c47a31bf"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/rust-lang/rustfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb003f601f7e97ce4ef1a4cf23f9e5b35eab087d31757b37c4ea804a278e274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1047fcdd002ac5189641374ba680ea9cb92d13b52ced30698d8d3d8853ad7dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "e780b81a82b67a572eb2a46d7392db6f107ce1d4870e5d77ae169c0095d65dac"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cfa6db0233217adb5d9a0f9ff64253afa137ca9b0983a5d332b0b7c9ca705eb"
    sha256 cellar: :any_skip_relocation, catalina:       "4a2eae7078777ddb02514994cece25febf9600cc1c107b74a5f616dc93f5ffc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bb85331af1fdf0aa6eebb41ee687254dba63ef921faade71752fa576b34fa1"
  end

  depends_on "rustup-init" => :build
  depends_on "rust" => :test

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    # we are using nightly because rustfmt requires nightly in order to build from source
    # pinning to nightly-2021-11-08 to avoid inconstency
    nightly_version = "nightly-2021-11-08"
    components = %w[rust-src rustc-dev llvm-tools-preview]
    system "rustup", "toolchain", "install", nightly_version
    system "rustup", "component", "add", *components, "--toolchain", nightly_version
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "rustfmt", "--check", "./src/main.rs"
    end
  end
end
