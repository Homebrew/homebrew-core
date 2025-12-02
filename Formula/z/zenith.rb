class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/refs/tags/0.14.1.tar.gz"
  sha256 "73d704b3cbf93506c22f3a7d98ae1a75011434a27a978dd0a7b6b30c7794423b"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2774e00fb53ed4446adc9916a1ffc4a2fd639e862b73fca0b4efde11651b14e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "27a11d6590b2e48b771af993c0b39a3bdfcbc629f97837fb633a199203d1a013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a756e7ce1451f19ff41f5d41207cb6d7638b081399c365ef5d9ffd0c8beb3794"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b52ba65cef2bd5122e967f6115e83aaf94c7f0016f1005c45614bbf790184ecc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436fde6c104ba8f224fc7076df51b652f3ff3d9031cfcb08cd5884cde42e4125"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4172d5c72a51ab8aebba7d4c47070b0a8cefdb40a8b73b928ddd02475dbef81"
    sha256 cellar: :any_skip_relocation, ventura:        "f177e534fc869dea3f2dc14f4ac29689c646991afd43b7e918b57b55d4a50395"
    sha256 cellar: :any_skip_relocation, monterey:       "9027e600ac7437f36f97ac6712c0d0183448b11929dc2cde6fb14153a029408c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a63fd0f8939e226783ff561e979b63f40e4c0d6b77cba2fdd4cafc0eb2662abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c7423ab047dead7279b56bd10dea35d14b07a58f26f97fef4dd065a8c0b8e5"
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
