class Shortpath < Formula
  desc "Small utility that will shorthen any path"
  homepage "https://github.com/andreicek/shortpath"
  url "https://github.com/andreicek/shortpath/archive/v1.1.0.tar.gz"
  sha256 "5bfe8b093d93b1db8370aa1a3df6bf79910025f49b5c4451d2ece61b2f13cd7b"

  def install
    system "make"
    bin.install "bin/shortpath"
  end

  test do
    output = `#{bin}/shortpath /hello/world/test`
    assert output == "/h/w/test", "Output is not /h/w/test"
  end
end
