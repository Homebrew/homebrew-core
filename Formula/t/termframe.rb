class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "61ea5c940b83f9ca9cfaab98aa23d04e2bb29de4d3829d895c3e178836981040"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19675ed4351b4388300369f6d496b15809273d28d5c34c9566ab6a693dcdb631"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ba621f9bd9971d7daa03fa27518928f3f7577c8b8f61928a89b0d8884f4e7f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ee388e0fa2ef061f04cf6eda92fb6adb291ed1a76d36f2602a33fb98bbc445b"
    sha256 cellar: :any,                 arm64_linux:       "9fed47216a2ef888a5e5c8533356cf782a6af669009827d93123280aecec2320"
    sha256 cellar: :any,                 x86_64_linux:      "2a72ae5492e02d7daf9359305f85c0bc9de218414657e6e6c5121dd6bb868516"
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
