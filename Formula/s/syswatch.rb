class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "3f0129defa91da788730d1d30fe0d25cff99f62338b9028f7b2ad6a3de67e1c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7233f5d45bf353dfec06b6147217e2b66355bc2aee91d43892854a4f6766b57c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e5669a7377656c81dfe0dd20cedc3a04f711aaa21d6328cb2403d7dc4148b76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "964b0b370d5f73ee1213f145f18de261b5bcecfbb0caf1474265bf805ad3cded"
    sha256 cellar: :any,                 arm64_linux:   "5a6e652dccaf9136a26f8137bf0202f5f6e7d93b0760ecf59f97fb6d4b57dbd1"
    sha256 cellar: :any,                 x86_64_linux:  "b0992d9e419c43cc01aab858729b791881fff95a6ce9b19f212bc08842c777e6"
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
