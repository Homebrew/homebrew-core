class SlintCompiler < Formula
  desc "Compiler for the Slint UI markup language"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "9c921f375de12fcf8647ddf076cf13af579b5cff61db5800e378cbedea9bff19"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    manifest_sha256 "9d0ae492fe871fa25e39a1e83488185a14cfafeeac8a643b50994ef960d3e478"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd0280a5959a6f2a8c3ec93121da301eb029e767c932db4cd6ccef946ecb9e45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0dca6b7d62d8e8f3e8129ef6db3bdf0d1b5160cdc0749783c24cba8c4105242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f16e39500e28f13cf13052e8077a2f44370f5c8fff4876e520b568c88fc7f6a6"
    sha256 cellar: :any,                 arm64_linux:       "e6aa8292ff43c6aedf9d2d94d4a35f093b0c2e57b5469f56ae097e90a6e5f90a"
    sha256 cellar: :any,                 x86_64_linux:      "a63c5a0ae6c3ecc2c767c0722f3160d2b3111e3b189d6ac7200d4e10691e71f2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tools/compiler")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slint-compiler --version")

    (testpath/"test.slint").write <<~SLINT
      export component Test inherits Window {
        Text { text: "Hello, world"; }
      }
    SLINT

    system bin/"slint-compiler", "--format", "rust", "-o", testpath/"test.rs", testpath/"test.slint"
    assert_path_exists testpath/"test.rs"
  end
end
