class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "61ea5c940b83f9ca9cfaab98aa23d04e2bb29de4d3829d895c3e178836981040"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4fc65f02811280837d25dc6da5c11dfd64c3ad645d892050c6135fffd975d897"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9d0502e0877855f83515604f488409f6e32317cc4f0d59e3d3d62bd53213cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a57b0102491cab7148978f44e161df6502642339a653479c01111fe9dd39eb7"
    sha256 cellar: :any,                 arm64_linux:       "6ce147a30b27cfb5a40333ec7c5f23bef1311fdb1d6a76f17bc056270f948a96"
    sha256 cellar: :any,                 x86_64_linux:      "979665e7b091a068342e050376cd692065272197ac271be2ee01d832a5db2910"
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
