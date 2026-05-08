class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "b0f0801ad32acb71107ba7a48aa5a01a2ab230639b13b444e012fa105b4b1d9c"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "536d68f5284a23e29f96753e445930d5fbd039ddfe4e2dcae45388a68ed501ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd9a63bed19d8ae2fa45bb3d96e1cfc840193f19f12618ba868fd90d9b7d500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cd654192670474d1a517760a81338c44bee34bab778b298524a66b5f0bc79e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "78071dead9d87d5edeb95d488af4eba9ace2f00af8740869804622b235737d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb07f25e1b80f827940f9dc8bc9a1774e8e570e263b80b83f3393e25d2de9317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e046118fcf8c2e1e6340e7bb7d6548bf8e3b85c11a067478f4f88c8a7cc8d39"
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
