class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "91d7fcf304a53d7645922bc2304337f54688a219831cc23c2dd9cbf24ee9b753"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5c5f1dd67389f31445ea2be56045df8d35dd85a73a754647a125b594c48860c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eefab2e24b6ff913addb6674696baa67dd51adee9963dc00e9b695ce414ab0f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b1fbdcb1b022a48dc4eff55d88390f97c28c75bef2459097806ef97a83e4beb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d0aac496f4f08d839210179ac911ddacd3048513536271af1025b186f8af30"
    sha256 cellar: :any,                 arm64_linux:   "0cf023fd190b76a795f4ba94d9ef92ce007c1ddaaff1ac9618b93cad806a5264"
    sha256 cellar: :any,                 x86_64_linux:  "cc4986fc357a626784745870932ea049ecbbaba9da629d5987983756becd6a70"
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
