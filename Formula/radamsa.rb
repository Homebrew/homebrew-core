class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://github.com/aoh/radamsa"
  url "https://github.com/aoh/radamsa/releases/download/v0.5/radamsa-0.5.tar.gz"
  sha256 "e21a86aa6dca7e4619085fc60fb664d0a1bd067ca6ebfbcb16ab2d57c8854cb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8e50d1dcb62a824b4ec3ae2c768a454deb3459d43ea57ef1fe610a0e1741c44" => :high_sierra
    sha256 "6fdb159c26f40239fbc9cb382ac42770ffae948d043e6972ba6c23c922b88587" => :sierra
    sha256 "44569c384623b1419a5431a8ba9c48743854bfb3ea79e3736bb1ad63d1fe04a1" => :el_capitan
    sha256 "184f9a9d1c030ab7ee83b84236f3749e1d3e0de11214166b264c4f52af902fc6" => :yosemite
    sha256 "fd10a5879e5d80d0decfc10b96a9a2bdbdbb3ce667b030a51ff152566020353b" => :mavericks
  end

  def install
    system "make"
    man1.install "doc/radamsa.1"
    prefix.install Dir["*"]
  end

  def caveats; <<~EOS
    The Radamsa binary has been installed.
    The Lisp source code has been copied to:
      #{prefix}/rad

    To be able to recompile the source to C, you will need run:
      $ make get-owl

    Tests can be run with:
      $ make .seal-of-quality

    EOS
  end

  test do
    system bin/"radamsa", "-V"
  end
end
