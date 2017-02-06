class Xrick < Formula
  desc "Clone of Rick Dangerous"
  homepage "http://www.bigorno.net/xrick/"
  url "http://www.bigorno.net/xrick/xrick-021212.tgz"
  sha256 "aa8542120bec97a730258027a294bd16196eb8b3d66134483d085f698588fc2b"

  bottle do
    sha256 "a7f818904878107dd9133834b044415684906e5e2ac37b5b015ca9f0b0868836" => :el_capitan
    sha256 "913496241e1fdf0df5895a1bae3701ca64dc912a174a1f5efe80d5ad56e9e73f" => :yosemite
    sha256 "dbe2a1f793f6f7421885241c2caae5af92fde79fc7317a9b447c03b0bbac9da9" => :mavericks
  end

  depends_on "sdl"

  def install
    inreplace "src/xrick.c", "data.zip", "#{pkgshare}/data.zip"
    system "make"
    bin.install "xrick"
    man6.install "xrick.6.gz"
    pkgshare.install "data.zip"
  end

  test do
    assert_match "xrick [version ##{version}]", shell_output("#{bin}/xrick --help", 1)
  end
end
