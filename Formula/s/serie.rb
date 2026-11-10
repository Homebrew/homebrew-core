class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "5308ce8d696465642ab2c0dc5c5b9c30541af919b61236457a9e2270d1116a45"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db22578e4b6be44fde062b09c0cc6d32d25c3cd73a63da4a13ac3f943b22a4a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41a62e5ec18e4aa37b8755291a620169136b68f0b893065d548341dcbda32cdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed1b991938aac090dd715fb870fcc1cee29659dd8e7a868673eb2acc9353ac22"
    sha256 cellar: :any,                 arm64_linux:       "44192ccea1cb819f64d662a12bd31b7443321e523cd5b13bafdc11d62d821eb0"
    sha256 cellar: :any,                 x86_64_linux:      "6770fb72ac2423bb930f6f39e857e0518e734b787a6394d2df67b696bed6b3f7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/serie > #{output_log}")
        r.winsize = [80, 130]
      end
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
