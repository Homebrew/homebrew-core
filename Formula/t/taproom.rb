class Taproom < Formula
  desc "Interactive TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "66c8c6ab96f08382b95c3f8bebae15915c0bc1678bcecb4811cdab6f21063e31"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "859bbe985fd853fb4d02ba6f0190e97737bf3d14cc632de905ffbca0586f1de7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "859bbe985fd853fb4d02ba6f0190e97737bf3d14cc632de905ffbca0586f1de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "859bbe985fd853fb4d02ba6f0190e97737bf3d14cc632de905ffbca0586f1de7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48b28b453e4c13d2e28d696d147e7d7363265006bd1263892b8fcc7c28fa025e"
    sha256 cellar: :any,                 x86_64_linux:      "36999c5b738dc2c65639efdb35cc6e1bccd402cd7800b4890277c00164a694fc"
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
