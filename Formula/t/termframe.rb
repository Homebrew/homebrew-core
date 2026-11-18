class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "16f40c1ee6dae9d60111855cdc413e6664abfd6876072415f9f01d3b0f5f79ef"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6b0b6f4b7d4f7a9a920747fa9cc774e5254dc435f7ab91e1c3559e47c7063a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "158094f47a6bb5bcb89f32179e66ac6bbd081d0a58e4027314074f7bef68aba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2c422cb234fcd4271c51302db099af85dc819e0e3e30adf352bcbe5daecb241"
    sha256 cellar: :any,                 arm64_linux:       "35386a3d3932673d820852e38df65b29cce99039c508fa1c0d28cd96dc5dab3b"
    sha256 cellar: :any,                 x86_64_linux:      "c8dcdcec5123b4ecf179291fa95a97a84fdea54fe78299a9f2a9af458423f3b2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `test do` block downloads fonts.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end
