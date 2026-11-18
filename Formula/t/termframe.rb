class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "16f40c1ee6dae9d60111855cdc413e6664abfd6876072415f9f01d3b0f5f79ef"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d9083a5368479e49972fcb7ccfc865b8fe3b4904fc24ea7332926c745ac01b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86e83e873fcd63fc981d148234a4f5aa9373be9ecd66acbcba465d419cea773a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6068ab4c2d466cec9a4ceb361104cc6f6f22d6141475d5c6b175316552d50cb3"
    sha256 cellar: :any,                 arm64_linux:       "80807469bfa5f367b33f3b696b15de8c0125ae2b33c1daf424577fb631bc7747"
    sha256 cellar: :any,                 x86_64_linux:      "33910a567f393e8544a1a248b0fd1b2289ad5f2a5427f3f2bc4e8e2a53635ac5"
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
