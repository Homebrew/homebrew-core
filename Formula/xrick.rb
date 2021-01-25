class Xrick < Formula
  desc "Clone of Rick Dangerous"
  homepage "http://www.bigorno.net/xrick/"
  url "http://www.bigorno.net/xrick/xrick-021212.tgz"
  # There is a repo at https://github.com/zpqrtbnk/xrick but it is organized
  # differently than the tarball
  sha256 "aa8542120bec97a730258027a294bd16196eb8b3d66134483d085f698588fc2b"

  bottle do
    rebuild 1
    sha256 "301f75c04e2c98c81b58868d7357e817b7dec1bc8a29747b27f088a10c1863ec" => :big_sur
    sha256 "b391e62a9cf0a3537ec68c03d215370d875a70a90fb7a8cb48cac8cc7281e2c2" => :catalina
    sha256 "cf85542617f6e39a8fec0239a57d1bc1707f50289e5c91bee89e84664603f43c" => :mojave
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
