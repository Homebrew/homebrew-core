class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a8ef49302b8d17797fb6c726251b8b6f9705284b20fff739b2300fc151ab20e9"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edcd949ecd3a2de6c4be0fbf0a3fcad0ac565d8b621e2a1ceaf2f3852ae24078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b979a5e6b16e4a7646db63124c29978f1c21c380e4e8d72fc7662d240109c3db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae132d02c894a05e2f18c9230287b9767b3527aa491c22b2abb45710fd7a71b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3415adbf1bc506927a20eaebd4c69afcb43b6e556f61e0f97a0df0d344e0adc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ce68c34c6a4f5ea3fbfe0288daae09cff5ac04df7881003bf9f2709ddab95e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4876f3f30d814b7791b65c100e0a0bb53c63a8f7c881d717400e35903856eb2a"
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
