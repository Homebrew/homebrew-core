class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.6.tar.gz"
  sha256 "47a3cf5cef9d87dea223ef1c8fae3cf8c2ae0673d9eb4c8d73d733ce8ff45619"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199e629ef6386f815a96b097540fdaa66e89a917a173d5f41c547e9b3b792444"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91acaa4fdf4a518890230e765da744990ecdd9ecbf308dfbafe7cc26b5b654c8"
    sha256 cellar: :any_skip_relocation, monterey:       "3efa45b62460e33061a77d58c040ae6ef6d235ae344a3dcfaca4e3e7f6ddd514"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dbacd10d72b7b5ec356081908444652a964c570f93a931dcbd5e039d5547c68"
    sha256 cellar: :any_skip_relocation, catalina:       "7f52bc1fef4395083b6eaf27b25922a621785e5f5aab0cd6ca1776f3af4ddd68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfbb7bf0c006fd09e463af561ee6d6e71c81d9684df445f636834ee64baa4214"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # try a query
    opts = "--search-engine stackexchange --limit 1 --lucky"
    query = "how do I exit Vim"
    env_vars = "LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm"
    input, _, wait_thr = Open3.popen2 "script -q /dev/null"
    input.puts "stty rows 80 cols 130"
    input.puts "env #{env_vars} #{bin}/so #{opts} #{query} 2>&1 > output"
    sleep 3

    # quit
    input.puts "q"
    sleep 2
    input.close

    # make sure it's the correct answer
    assert_match ":wq", File.read("output")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
