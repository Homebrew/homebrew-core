class Taproom < Formula
  desc "Interactive TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "66c8c6ab96f08382b95c3f8bebae15915c0bc1678bcecb4811cdab6f21063e31"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e26c44d3f1821d685aeb6c52c535abf3094461f1c3c41db3d12325e811fb4d6b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78a73070fe3f2815fd0e32ac46190f259fd3820c6da4fdab7d39d757b7e47793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78a73070fe3f2815fd0e32ac46190f259fd3820c6da4fdab7d39d757b7e47793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "78a73070fe3f2815fd0e32ac46190f259fd3820c6da4fdab7d39d757b7e47793"
    sha256 cellar: :any_skip_relocation, sonoma:            "aceb12e9b3656527606e8cef30da476be4770a96c6d9db135938fbd6657c0882"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9c5c7a64b894f51329af881309d1d4df87d01288350677c3a340e30b8cb9a41"
    sha256 cellar: :any,                 x86_64_linux:      "d7a4da4465783d5db774eae5af6b74c6f8d7abb63a7d93f0f966df950f5351a6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taproom --version")

    require "pty"
    require "expect"

    # taproom is a full-screen Homebrew TUI. Launch it in a pseudo-terminal and
    # confirm it boots and renders its data-loading screen, then quit cleanly.
    # The loading task labels are drawn before any network response, so this
    # exercises the real UI without depending on network access in CI.
    PTY.spawn(bin/"taproom", "--hide-columns", "Size") do |r, w, pid|
      r.winsize = [80, 130]
      begin
        refute_nil r.expect("Loading all Packages", 30), "taproom did not render its loading screen"
        w.write "q"
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when reading from a closed pty
      ensure
        r.close
        w.close
        Process.wait(pid)
      end
    end
  end
end
