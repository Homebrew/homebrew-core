class StarlarkRust < Formula
  desc "Rust implementation of the Starlark language"
  homepage "https://github.com/facebook/starlark-rust"
  url "https://static.crates.io/crates/starlark_bin/starlark_bin-0.14.0.crate"
  sha256 "0c33c0ca1ebd9da2f735029e3815a49a593273567315a0e5b22dff4d2899f196"
  license "Apache-2.0"
  head "https://github.com/facebook/starlark-rust.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "450b0a8c5459c48edfbf882f6cde9a829b775787503486f20e75fefe43a38122"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00e5c0d465eaef8c5d2d392077961684fdaf7f5b9fe1844ca0e5042d6e2f7e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cb4a08924c38a31e71e7d74e4fd63c9eede1c908ccc39f7410c0a9ee3195ffb"
    sha256 cellar: :any,                 arm64_linux:       "306781472f332709f88d6ae1db83a3743be1de5c955787ab57a80cf66b460249"
    sha256 cellar: :any,                 x86_64_linux:      "7b9a1b99ddba0a450592444aa4be473ed471baf451edb55920703fd6b68e29a3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: build.head? ? "starlark_bin" : ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/starlark --version")

    (testpath/"test.bzl").write <<~BAZEL
      def hello_world():
          print("Hello, world!")
      hello_world()
    BAZEL

    output = shell_output("#{bin}/starlark --check test.bzl")
    assert_equal "1 files, 0 errors, 0 warnings, 0 advices, 0 disabled", output.chomp
  end
end
