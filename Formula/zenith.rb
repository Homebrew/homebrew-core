class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.13.0.tar.gz"
  sha256 "e3f914e5effb842f5931b5b8310e05e90a40f6aff7384b54a9f18a73ba567032"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dfcb6b50f3cd3a485ca6689a230557ebfa5711d82f8539879aeb6d114296b83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a03f7329f0cdcd313fedbbd7173f7396fb2aa87d7ca9e762dd3d0b9382e5355d"
    sha256 cellar: :any_skip_relocation, monterey:       "986b3c40d3829157ab79738cfef20d9abbfd1f80dcd7fe7e36e63f59bf619a58"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e9c45bac27dbdf7b06d1e9c030f120a479e30373a9351345836f4a021f2cfb2"
    sha256 cellar: :any_skip_relocation, catalina:       "8e53e8178188527bc7b459cab81127cad52824928b107556afcdd87b619ea138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285aedefd862799bf77496261d817cc410070e6112f236da1ec074934c2262d6"
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
