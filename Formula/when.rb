class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://deb.debian.org/debian/pool/main/w/when/when_1.1.38.orig.tar.gz"
  sha256 "139834945142f5e3ea6b20f43ba740d30b4a87b42ce5767026094e633dca999f"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "652f84f91cbb5bd61f34b0b90124fc17beb94654150b548348aaee28951b1510" => :mojave
    sha256 "7645dbb878781cae6f691fd4b0888f85a37ce55eebb7871276aad1bc0c8b6707" => :high_sierra
    sha256 "7645dbb878781cae6f691fd4b0888f85a37ce55eebb7871276aad1bc0c8b6707" => :sierra
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
