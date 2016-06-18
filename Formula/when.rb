class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/when/when_1.1.36.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/when/when_1.1.36.orig.tar.gz"
  sha256 "3ff95c1881e8fe25c82943720a81c9b9b3bd4ac002cd8ffc2d25c588fe7d50b1"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f533fd4c38cc717e11b9fdf3c8143cd2b58aeafe344b73027e3255151815d135" => :el_capitan
    sha256 "e7033ecfcf3e30fabace03990e56b7acb60bf20c75e46c66ef0af093bb8c029f" => :yosemite
    sha256 "0aece5543b4b9eaf405bfd7527a142975b5e2845b94d8cb2ca9ca4147008b742" => :mavericks
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<-EOS.undent
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
