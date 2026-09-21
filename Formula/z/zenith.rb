class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/refs/tags/0.15.1.tar.gz"
  sha256 "ffa3412c19e99f9ef691f86e4f9b1a342add2b0504bb3ea7f0b57daa17e4b731"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02d20fc572b64bf6c4b295ec3d19ed8738a271c013ced10fa3b8cd72f8179b91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "448ce4fc97b127ff83fb720d14138cbd8cdf08a7b8b7a8442921ee0812ad2be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90fd0ebd769a609dcef73a6b33dbec3db75021e635031de00f46d57a0c504cc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "75339d1afa6a66b06965cfcb9a33c75961ab5634a6adb3d2933ec5be2010f6c0"
    sha256 cellar: :any,                 arm64_linux:       "f873db30d1df896ae03617e4c88686624e9cdf9b9a4e6ce21e176691aef8c87a"
    sha256 cellar: :any,                 x86_64_linux:      "6b27201865e9774bfcb3f91122fe462ea4ff63fc0658121d952ec5ea981db79c"
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
