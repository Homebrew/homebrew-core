class Xtail < Formula
  desc "Watch growth of multiple files or directories (like `tail -f`)"
  homepage "https://www.unicom.com/sw/xtail"
  url "https://www.unicom.com/files/xtail-2.1.tar.gz"
  sha256 "75184926dffd89e9405769b24f01c8ed3b25d3c4a8eac60271fc5bb11f6c2d53"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c50e24a2e599f9adc556452e3d1493cbfc5bc665858363d7c0f956acf6136a8" => :mojave
    sha256 "483c983bc4d4c15a2d157c700d91cbe801f383956ea5e554a5d96e4a8f476ba5" => :high_sierra
    sha256 "d230b5111c213e9294f86f01c651501a87c42f60ed30929144e21ed4bbef4ecb" => :sierra
    sha256 "a579041c4d693dd444464228dcd0175e79f31708b62ad3ccf55a8f545ce67ed7" => :el_capitan
    sha256 "60a2bcabfb83e8ab4df95b2417ccf5c49c5ca242853ff16e2a106f3e37f6005e" => :yosemite
    sha256 "939117402a33f5037aa7e49f5228e0d0b852e0e39e85d81357b8955864bd26eb" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    man1.mkpath
    bin.mkpath
    system "make", "install"
  end

  test do
    file1 = testpath/"file1"
    file2 = testpath/"file2"
    touch file1
    touch file2

    begin
      p = IO.popen("#{bin}/xtail file1 file2")
      # Give xtail a couple seconds before and after so that it could
      # relatively reliably pick up the changes.
      sleep 2
      file1.append_lines "hello\n"
      file2.append_lines "world\n"
      sleep 2
    ensure
      Process.kill "QUIT", p.pid
      Process.wait p.pid
    end

    output = p.read
    assert_match "hello", output
    assert_match "world", output
  end
end
