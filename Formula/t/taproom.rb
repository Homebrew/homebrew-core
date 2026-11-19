class Taproom < Formula
  desc "Interactive TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "626329f1bdcd3e982c690a90e1147fc995584c69583f20ba7dfb6cc72419760e"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdb71401f5c1857839f535edc0f816e3116f59b0e6aeae4fcabfdb41ccd3ce22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cdb71401f5c1857839f535edc0f816e3116f59b0e6aeae4fcabfdb41ccd3ce22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdb71401f5c1857839f535edc0f816e3116f59b0e6aeae4fcabfdb41ccd3ce22"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17e159c66a4af2a38a5ddb7d0241564ff18c28d3416347408ac56a7649224eea"
    sha256 cellar: :any,                 x86_64_linux:      "809736bd4367c83214cfcf3f03e533a9bd119fd32dbd0f05b26f61ebf2f19a8e"
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
