class Rgxg < Formula
  desc "C library and command-line tool to generate (extended) regular expressions"
  homepage "https://rgxg.github.io"
  url "https://github.com/rgxg/rgxg/releases/download/v0.1.1/rgxg-0.1.1.tar.gz"
  sha256 "6566cd05d116475e98ceb57a5fdb25d8743f7381799aeb8e218433ff4fbb139f"

  bottle do
    cellar :any
    sha256 "2d6e655c81a471deca35be0df8843f92f3e192f17a77a55cfcecfd0a0a2f3408" => :catalina
    sha256 "6104ec3b5902403a86044b75d4f97f522450f42021dead1445c5a08d0b09c35a" => :mojave
    sha256 "5a3dcbe7906757077109d8a6b2c6cce5389de96175392ee38daeb657da2e5e5a" => :high_sierra
    sha256 "3b15445df62f8f57c4447a85cd719251f8820596548913e76d9738124d08f763" => :sierra
    sha256 "e84c6dfcb4195ef84bd4c5373bfa6029ea4d8600f94b58bc97fbee7334bf3f74" => :el_capitan
    sha256 "68a4566c40db42aa298862e8b2cc02dc16dfcb9f373454e48be31e0899dc6a64" => :yosemite
    sha256 "6fc96e2fbf981e67c6374928430dbfd20691d59f6b5dd7b1e255284edeeb6fc5" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"rgxg", "range", "1", "10"
  end
end
