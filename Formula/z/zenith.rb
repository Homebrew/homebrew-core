class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/refs/tags/0.15.0.tar.gz"
  sha256 "f92ed87b66f97b1f6c5863a62cc795ec877510dcd0284fba822ef5dc091b9355"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7d5ef787ca0afe7d120eebf5ba5c694ec859968da494518ad999c2a28e1f5df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0c3ca47e1bb97224fb57defc71e9d08b6c5583fb9d44089b25e4848ac425af0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50dacb91e7dd564d48126fd0d2812f62763c65f6ecfaa50b457033571e4c1aa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4fffebc7dd48c5f91beb8654388e3a47fb4833d3e235940011d6a77bbcd6e87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9752c5f88c7ca600c27476b08fcbfc7b4683c4331b3e7ebdc4c03c88c74d082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a18a32e1d8f7c17b510fe207097779f64742597941b769daadd4404dd654e1d5"
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
