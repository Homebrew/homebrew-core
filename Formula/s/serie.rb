class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "7092c844152a0921fb29b2d9084064c632486aa12bb76a9827fe1435623e756b"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36845cfc0cd696d70f786b06f5a0e400648210f5e060b355f6a415a74c5ac6f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94dc3c2bf74e808be630be3295697531cbc5258cded0d19f98dd222b16c0dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72b62370ac9312137793adae2ee343384aa28cedf11f98462ed8cd3a6aa1ec80"
    sha256 cellar: :any_skip_relocation, sonoma:        "08fc7211870330c72a1282244ba10529c92806b4ada14bcdb7c050205b42cf30"
    sha256 cellar: :any,                 arm64_linux:   "117ed7e9d4dcf72eea689cda4a58e5a15a6779e311a90a2652dd7dc72542766a"
    sha256 cellar: :any,                 x86_64_linux:  "660884fceb44f79c24683caed9067f2d27d83ce27761f09a9d378b76078b5155"
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
