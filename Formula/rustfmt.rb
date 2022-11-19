class Rustfmt < Formula
  desc "Format Rust code"
  homepage "https://rust-lang.github.io/rustfmt/"
  url "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "dc29a1c066fe4816e1400655c676d632335d667c3b0231ce344b2a7b02acc267"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/rust-lang/rustfmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae00013ef65a9ed015c968b8ee9daff7e6147cc5a99c8cdac657ee92f4a8461d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3812711969be43a9a8a2636b5aa7a76fdf8f1a4b59301cf3224cf36e1ab3422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b44fb4f1512e6932dae71f77992458c47ef45d26efcfe2915c734b692385d19"
    sha256 cellar: :any_skip_relocation, ventura:        "f35c099a16fd131a423d5a181730d569332963687e9b9d052b1ccda54daa5569"
    sha256 cellar: :any_skip_relocation, monterey:       "95e6c58fe6e57aab6b4824e79eca7f1985cdd57c30e4d8dbb8bdc6c54b4c57c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1a7a2e82215d39777dd959159ae96d130265f8186e64b15254912b1553e4181"
    sha256 cellar: :any_skip_relocation, catalina:       "1a2d1361705ac673b214c228679a84ede04c843448eb756ae71f5b1ab3e7db01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b770894376d5273adc2e8731db63e00a32ea93b05cad6ab94a401e7aa1a9ead"
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
