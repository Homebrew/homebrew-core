class Rustfmt < Formula
  desc "Format Rust code"
  homepage "https://rust-lang.github.io/rustfmt/"
  url "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e5d96f28e9a6c559eba06f3631fa552bb664cd5509fab2248c6627dd09cd9864"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/rust-lang/rustfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "423647ad2be54be15e4d74087fc63ca8ea06de50fe2d585ac1aecec4be2f48cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c38e4967aeeddf79bc97fa6164c5f573df29d8fce634a4a6e39c60b1719e4199"
    sha256 cellar: :any_skip_relocation, monterey:       "68b8279cf33d308adf45410c68c18f65796eeeb78dbfa15d816fe4e38710cdd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "73a17404a40d5e11f8138fad876c1108f390906105b540b27935ddcc4a21a1e4"
    sha256 cellar: :any_skip_relocation, catalina:       "3d953ad94c63251aa59a0efe5dd6bda8cdecc4e63090eb580c0221c18bc49474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "214102e7ec369b4e73ebd146e2b6512277535e857fc7dd10413fb3aa4e1a9ab6"
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
