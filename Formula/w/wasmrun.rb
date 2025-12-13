class Wasmrun < Formula
  desc "WebAssembly runtime for development, compilation, and deployment"
  homepage "https://github.com/anistark/wasmrun"
  url "https://github.com/anistark/wasmrun/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "b39a35f8e95166fd6dde801b3951c1312a4396e9e39438a96f87c51a5e6fe38d"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasmrun 0.14.0", shell_output("#{bin}/wasmrun --version")
  end
end
