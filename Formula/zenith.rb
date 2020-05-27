class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.9.0.tar.gz"
  sha256 "122a3b385ed7e6ea6b175cbdfc210d3b0315991704e4f0f0c8d477563631094d"
  head "https://github.com/bvaisvil/zenith.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4887f23e176f7a7ad6c72ee82d565b171cb64ad4afbc6602fa4bfa11cd94219" => :catalina
    sha256 "c625f229bb3b2da3076323762cfaad58718df20a3e3f3951544d881879eee827" => :mojave
    sha256 "5271d90f13aa7fab7cbbe638eda4c7db91dbefaaa9a9e490eb575e7ab0f14203" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    require "pty"

    begin
      (testpath/"zenith").mkdir
      cmd = "#{bin}/zenith --db zenith"
      output, input, pid = PTY.spawn "stty rows 80 cols 43 && #{cmd}"
      sleep 1
      input.write "q"
      assert_match /PID\s+USER\s+P\s+N\s+↓CPU%\s+MEM%/, output.read
    ensure
      Process.kill("TERM", pid)
    end
  end
end
