class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.13.1.tar.gz"
  sha256 "1f2914a1ddd7dd76cca0e0c07ca77bd048addfd80fc6329ea7b83647ea66020a"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df4b38d5c3c167660e4fa6b3d0f3de6b40e16f8b11271a30af12b583a68aa806"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd23eca4646c5194bdc400bcb2d5a8661a68f96d95596c30a784671c6fd3b51c"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a8c6ad3b806d7c635eb55cb37f781f28f853a1493a55bb70ed407cb161c8f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f50dca2bd86eeda17a7c0819470d5d969708f119a58307f164fe5b928401a93"
    sha256 cellar: :any_skip_relocation, catalina:       "9dcb4f2c8781f406526a1ccb1cb31fa60e99f96cbc21ccec0faac88c03feb5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09210872f3b111381d32b0d53bb176b183ac2180e08f417f6e6aa0a4e9f7dbd3"
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
