class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2d8086cf67b3a5cf661d2c2ee552e29c40a1f46b655170360d9f8aae9cd097e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecaeb84842633946cc10619b0e6a5fc5f003d311d422d4e37d15842ab162f9eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ab613c0e418b8d05d4f638309ae54f5a2016662080e275435c55b78b5bd290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d678d5a20b4bac94c4dfe8b9a18fa32f44e9abc8a0f8aa577828c35f72f6f07d"
    sha256 cellar: :any,                 arm64_linux:   "d84e3a0757a8b15f60e6a4fa2210d5cfba7445c0e0034d9d5248c35517c34299"
    sha256 cellar: :any,                 x86_64_linux:  "767b96c83309303811d7c263b162fd76513f801a0e532b624c516ef6251f3a9d"
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
