class Recoverjpeg < Formula
  desc "Tool to recover JPEG images from a file system image"
  homepage "https://www.rfc1149.net/devel/recoverjpeg.html"
  url "https://www.rfc1149.net/download/recoverjpeg/recoverjpeg-2.6.3.tar.gz"
  sha256 "db996231e3680bfaf8ed77b60e4027c665ec4b271648c71b00b76d8a627f3201"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b9e6cc406462435f7efc7bf6686205f29beba8bc5f481c6bf754a53d37f9411" => :catalina
    sha256 "89bd9fe522bc64508a3c2925edda2a3ae3cfc32e7ff59f7e70eb1069352129b2" => :mojave
    sha256 "ce460e293cc4c4c5bf3650cf9860e7b06654017473c414dc88c1df9d82e8466e" => :high_sierra
    sha256 "453b0d2c88be1b885407e38900ab0303481e9957ed5c160cb8e6456b6a2f81c2" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recoverjpeg -V")
  end
end
