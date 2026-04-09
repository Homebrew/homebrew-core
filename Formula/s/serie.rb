class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a24535b4b4039da560a4aadb8894735ae0d442e59ce81409f0d1598ff2af2c7a"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "070fbd5db78b9ee06777fe819684d64b0e1409c4d4d19f159e4680bc4fcb33cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad680752fe29340d56c50d146cc8ebc9de632c47952212fe5526592c4b6eb81a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d88faf6a402b1cbc3fe8c81fdb00eba941fac5a43a6dce92eeace1fc2bcf4611"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bc4f68a794ad6b532c5f8c06668e52df2910cfe3e596409d5c02eb410c3a4ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d5c0350859aa4ecb5d77be9f23fbbf16bb236a28ffa6c2b5f45a53bfdd21f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "632af99b8ebf0bea837befb6f13fae13ee198b84cef7640c82650eaafd608b53"
  end

  depends_on "rust" => :build

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
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
