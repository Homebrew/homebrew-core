class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "b3530bfc1e1c87844553873e68fb39370240c6a4b43fdf0361d475ab6b0d298e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba8fde5fd5b8be7dece90807cca09f14a288e0e6f99a29e2d8b676e5c7471f6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe8e06ada87482742232f9f0b1a0c8989ac2b14393111d6c27a48b2eca30071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "780c5ea6cf8d3ed0f06a9cc07acb9e501b5ace2f9b615794e80caa903f90301c"
    sha256 cellar: :any,                 arm64_linux:   "cbc0e08efc47836d376ea44d4ff8858b8781456cb59474da0b56e3e3b7e01604"
    sha256 cellar: :any,                 x86_64_linux:  "f3ab862e4728834acf9787d4718a69fc851d3b0bc409b38bf32b2fd37ccae5b9"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64 # test fails on Intel macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/syswatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").read
    assert_match "Services", screenlog
    # match text in help dialog
    assert_match "Procs tab", screenlog
  end
end
