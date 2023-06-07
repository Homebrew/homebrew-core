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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7e798fd4a122923dbc8e1918829b9e3359a7c414bc68bede6177fb7fd2453fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a72ea12db621b2eb9243573586d3b769330742dfc8bb45a55c9708964192b123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f929e8ab0b948d3638012111c33813c098e7060aa3918d42cbaefb99e9c43924"
    sha256 cellar: :any_skip_relocation, ventura:        "8211610bb6b9f31578a9990bedd73fc4a31ce0e70faadfffee3b065b4cb5746d"
    sha256 cellar: :any_skip_relocation, monterey:       "aa08396983f63d03a509641a4eec6a471cf5f6c3402ede16be76e7b5de517b71"
    sha256 cellar: :any_skip_relocation, big_sur:        "a31ea9fcae037b05887b2d1cb82c01602f61b3ac4161a5e63dacce70d0a9ea05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2326336b1c105cfeb1927684314cee9f38c5df89e27428e26264c0dec817f711"
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
