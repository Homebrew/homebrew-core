class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "7efb46acf02b13f2a0c39518ba740f120ff281b9dd20291e7f7bd5b6c274d0d1"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a5aaa002ebc4fe2e582d90c1731d0ddf7b1349dbbfa76e959899d57bfcffbcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4f26ff88657f5eace0901f32805b9487f9807c88f9a54d75989534eb476c49b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f1f703c5ea2d9adb3a1458fe5fe73439a6c5c8296bc9f45ca8ff12b952746df"
    sha256 cellar: :any_skip_relocation, sonoma:        "71eb82f2441e23fdf83d3921c632d7c19f1ed38aa2c78de5dacc28ab9a0c867c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec8e90eaedbd0e490431240283667b0c6f0b9516b873e9e6e2a8dafaa9175450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3fbd5d067ca54919cacc954355da772a252288e300dba3e5eebf07dcfb69db0"
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
