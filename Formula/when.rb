class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/when/when_1.1.36.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/when/when_1.1.36.orig.tar.gz"
  sha256 "3ff95c1881e8fe25c82943720a81c9b9b3bd4ac002cd8ffc2d25c588fe7d50b1"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7ed7b34c5d51139d447e0c02e3ca15986db8fcd279e9902dad3d23938d74c3a" => :sierra
    sha256 "9e2fc9c54fdf0984a9f4bfde45441f45be9b1a491197527a68608e8619923dee" => :el_capitan
    sha256 "d9c2db7f27a06e70583b88c17c299616b0b0b154874148b827ef97bde9e841ec" => :yosemite
    sha256 "d9e387024317d27260e29bcf3ea6cf08eec55b0dba291f0d9328f1b9e2353233" => :mavericks
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
