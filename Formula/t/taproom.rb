class Taproom < Formula
  desc "Interactive TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  stable do
    url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.6.2.tar.gz"
    sha256 "85ee7660bb76ed9277573d2c856bcfebd3181b919edf3862e7f9e15d32097088"

    # Fix version number
    patch do
      url "https://github.com/hzqtc/taproom/commit/a26afac788a5122356bf9c07c3c3d04fabae76d3.patch?full_index=1"
      sha256 "c9c5684f557ba7b3a5db9aee5b7c4a53bc41ac98f713aecd96afebd19ce1066f"
      type :backport
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a73070fe3f2815fd0e32ac46190f259fd3820c6da4fdab7d39d757b7e47793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a73070fe3f2815fd0e32ac46190f259fd3820c6da4fdab7d39d757b7e47793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a73070fe3f2815fd0e32ac46190f259fd3820c6da4fdab7d39d757b7e47793"
    sha256 cellar: :any_skip_relocation, sonoma:        "aceb12e9b3656527606e8cef30da476be4770a96c6d9db135938fbd6657c0882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9c5c7a64b894f51329af881309d1d4df87d01288350677c3a340e30b8cb9a41"
    sha256 cellar: :any,                 x86_64_linux:  "d7a4da4465783d5db774eae5af6b74c6f8d7abb63a7d93f0f966df950f5351a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
        refute_nil r.expect("Loading all Formulae", 30), "taproom did not render its loading screen"
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
