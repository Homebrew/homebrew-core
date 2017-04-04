class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://gitlab.kode54.net/kode54/vgmstream/repository/archive.zip?ref=r1040"
  version "r1040"
  sha256 "1f1ffb295138d02f01503b5eddd5c836811b7b02dca8a8cecc6a04b02ce9584a"
  head "https://gitlab.kode54.net/kode54/vgmstream.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "384e5c9dc2c362457c994225a68a2a4a77e3359d6ef075772ad85f284c2e1035" => :sierra
    sha256 "af90cbf62ba45286723f002d65f5c04f2c3abbd31abf9f9bc5313aa6e2ee9ba6" => :el_capitan
    sha256 "944871f693a695c31b2c07569a9bb8314b0a95ae451b68cb172ecd473d73f5a5" => :yosemite
  end

  depends_on "mpg123"
  depends_on "libvorbis"

  def install
    cd "test" do
      system "make"
      bin.install "test" => "vgmstream"
      lib.install "../src/libvgmstream.a"
    end
  end
end
