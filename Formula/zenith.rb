class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.11.0.tar.gz"
  sha256 "be216df5d4e9bc0271971a17e8e090d3abe513f501c69e69174899a30c857254"
  license "MIT"
  head "https://github.com/bvaisvil/zenith.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4accf1b1a4a1de8eb02bb8b2afd3c27f9bd8a1f2503b279bf042ea9fddba796" => :catalina
    sha256 "3cc4a5c58126668f090e865274961e87cd1395da544813a7af3ee57bcacac510" => :mojave
    sha256 "d8d023e54792ca540cddab0fda666b5163aa1ce6599078de72c5e4e1f1e046a1" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
