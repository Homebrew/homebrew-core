class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/refs/tags/0.14.3.tar.gz"
  sha256 "b092048d1a9ce7234584d928e4b103aaaa7e47589923cf4e48dfa8919b3f8d88"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c81ddc75796095724c82b528314108b9faef5bb5fc4b0f4957d6bce598a637f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7d440b1ca179d4cccdcea57576decde4aaeea001d6ccdaa8ec6b6190e74cfbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "951081852c40e287d187388d69d6d59dcfc096b461c68dbb4255af5bbaeb29a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "604878551ce967241a95e00fcd5a8c536143ac3885bda1c8e9ba709a10e3ac1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04e3f9eca98968d07a3695cf519ced235645d4123bd7cc1d10a569c6fd0fa55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f97827bc9854759a38f7e5cb6b86dc14a92152809e0d06d0815adec23af64f"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"zenith").mkdir
    cmd = "#{bin}/zenith --db zenith"
    cmd += " | tee #{testpath}/out.log" unless OS.mac? # output not showing on PTY IO
    r, w, pid = PTY.spawn cmd
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    output = OS.mac? ? r.read : (testpath/"out.log").read
    assert_match "PID", output
    assert_match "CPU", output
    assert_match "MEM", output
  ensure
    Process.kill("TERM", pid)
  end
end
