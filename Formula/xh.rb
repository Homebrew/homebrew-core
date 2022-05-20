class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "d6ec84977da567dd36a4c59d624dc1e2b1c77a21e2b0a10e463216120be8112d"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0249aacec0f8c4a1e8d8b72d674356ed12b603a26602a92b77b542aa825615b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "235db6cadf881787e40e64b0da0addcd4f374bc6fd51b571f3121a6cd171f8f3"
    sha256 cellar: :any_skip_relocation, monterey:       "c1f302ed2adad8f0ae61c16721ac39593515423c1c54ebcdfbeece58b167a0cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e709d9d7f99ec917202995b0f8942153a0ac9c0ace4ba91dfa919885efa01f90"
    sha256 cellar: :any_skip_relocation, catalina:       "58964f23fb620c8fd182a007ffa987cb9329c33c0823ff18d32224e374f369f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d32b0bd2e304c6895ccd2295823a8f1ce4189f436a2a931721f50b96a7915ff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
