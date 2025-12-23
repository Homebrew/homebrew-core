class Wasmrun < Formula
  desc "WebAssembly runtime for development, compilation, and deployment"
  homepage "https://github.com/anistark/wasmrun"
  url "https://github.com/anistark/wasmrun/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b97b06df7504b0ad2b57cbe2b5893bf3c6648ecb6dd7733b2490051a659ea1a8"
  license "MIT"

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasmrun v0.15.0", shell_output("#{bin}/wasmrun --version")
  end
end
