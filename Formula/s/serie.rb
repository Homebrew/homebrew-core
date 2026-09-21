class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "701f2c916db7756e38d0eeac8337942dc6392a090d7c5f4235f06be643cab05c"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "222544d21e2157ede100003dc4af38909b25c502e13e130b5c5ed9a21559de04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a8806ff2f256162896e9ebe637c4f27c8caec7dcf26aa560808457ab4eefcc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "035719d277d038dbf1f8f2c2911cd85993031febc51c146f4a577453319e15b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "87adf28d2cd7445ef08067ac8b099c1d9ecc4a352a30adc7acc1586d740b3997"
    sha256 cellar: :any,                 arm64_linux:       "dacb89175b1648ccb90ba7a116cd16847504f2dde910df0109cb84168a56b56d"
    sha256 cellar: :any,                 x86_64_linux:      "9b8e3af765d3f2aeea8e2fa207475a30c8be9bcc35be97512c2c492ac178d705"
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
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
