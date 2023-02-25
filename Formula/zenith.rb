class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.14.0.tar.gz"
  sha256 "2cbcea2625cfa97c161b974ad412a47e330f7fd31bec0479e329ed3606cfc569"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9704d8a28d5a9aa3c91ba4f60666653b8edbe24cbc7f45c5926f9ed645d24944"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1a9ace0e4078128fb378c9487dc2469526325d2c625298217ef1f8b5daf5a47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeeeac8902c3edc9d2b70a3a88640c855c47756787189174bccd417493081052"
    sha256 cellar: :any_skip_relocation, ventura:        "e75128e90b171c62edb97f339faa343da0d15ffe6f04b52a45ea9b8d86482c33"
    sha256 cellar: :any_skip_relocation, monterey:       "942ee49856e4fc203ee1b270c07169f48ab349cae845b9a46d73c59692789ff9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd572e0fb6e05f01b949aadd9d501e0a301ff2220daae4592eedcd92a18b42e0"
    sha256 cellar: :any_skip_relocation, catalina:       "46aaf1840a0b1c12a55a5ab7f8c865ebeea9acd198800ba509fa531422a69998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3332cd889a08fda83dba1b841b6062d8d5ea9a062d4b32f5d21aa44df2b79d2c"
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
    assert_match(/PID\s+USER\s+P\s+N\s+↓CPU%\s+MEM%/, output.gsub(/\e\[[;\d]*m/, ""))
  ensure
    Process.kill("TERM", pid)
  end
end
