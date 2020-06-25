class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.9.2.tar.gz"
  sha256 "dbfcb76698201891b44b1178022e6fa480e8bfd6ded33af04031edcc6685d6de"
  head "https://github.com/bvaisvil/zenith.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f1bdca3e08f8b57a52cd1db2a48bb0383a23f04c29f17358a1c5c40797119aa" => :catalina
    sha256 "8fc0737c8421303c724826bd63d1fbf1078f47b226bde1c4130dcb4ecd35c77c" => :mojave
    sha256 "b6b27f98ecd10f4028b421d026ba97b137de47ab5d799a89818703ecf059f6f4" => :high_sierra
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
