class Rustfmt < Formula
  desc "Format Rust code"
  homepage "https://rust-lang.github.io/rustfmt/"
  url "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "dc29a1c066fe4816e1400655c676d632335d667c3b0231ce344b2a7b02acc267"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/rust-lang/rustfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb6fd59f94829c11bffcf88cc8006fcdc5ad5b52815663f4b0eafd96639de423"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1aa9eef452302f36090c19add716914fae83e6cf78aeb00276c961992c7fac5f"
    sha256 cellar: :any_skip_relocation, monterey:       "0f7c8bf155fc7289caeb261421d4dddd18f6ba496ff8d8d3abb017615903a449"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd2d3f3d55962c9a78e033ae4132d459afafc0a4117e0b4bf97b4baab00eb422"
    sha256 cellar: :any_skip_relocation, catalina:       "eb5239d46b3d14b1fde083b7b586282035c2960c532c0e1929907390076d912a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "847eb7789ed39f6982e528cd22abba0d428398e093e183299a4eaf10e7abaf75"
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
