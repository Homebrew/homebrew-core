class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.4/tin-2.4.1.tar.gz"
  sha256 "58e714e130d32258a41ce829c3286c5d4edb9df642ca7a62328b006c1f756478"

  bottle do
    sha256 "8449ea4864b1fb5daa8f28f94b3561dbc0f165dbfb0c1c4fc7173f2552ad040d" => :sierra
    sha256 "6cff69c3cbafa44246b88cc5721cf497933b80f12b703de54afe4b00d8fa54a9" => :el_capitan
    sha256 "ca307ff45977125664a3e8add2f28bc9f37570a5150db8ad573ba7aac67a8bad" => :yosemite
  end

  conflicts_with "mutt", :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
