class Vorbisgain < Formula
  desc "Add Replay Gain volume tags to Ogg Vorbis files"
  homepage "https://sjeng.org/vorbisgain.html"
  url "https://sjeng.org/ftp/vorbis/vorbisgain-0.37.tar.gz"
  sha256 "dd6db051cad972bcac25d47b4a9e40e217bb548a1f16328eddbb4e66613530ec"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d007797235d2075ef13137bbbc16f2781e7657501f5d8c023acdd1b8a67fb91"
    sha256 cellar: :any,                 arm64_big_sur:  "5763a2b6c8f9c2d5c27e708a8cbc88f5274dcb7e44f5f5ecf2b29b909e18e017"
    sha256 cellar: :any,                 monterey:       "2425fba1e48046342e47fc515d958f5c76905679c4c8d2dafa9686860387f2dc"
    sha256 cellar: :any,                 big_sur:        "c70e02a12f7c232b752afebcee063ecb031eb120f64c58bb6a95325100aa6767"
    sha256 cellar: :any,                 catalina:       "b49eb04725bc5ab78fa94e261bb23598b4b4cacf1e8508a9ea543b0069947894"
    sha256 cellar: :any,                 mojave:         "75aa0134fbe5f63549d0e9328f6ae2d3513670e74d5f35ca7c633917a9383aee"
    sha256 cellar: :any,                 high_sierra:    "86d9a629d242005f13a1de8a591aee61455059b9072ab528afbebe63ecda9613"
    sha256 cellar: :any,                 sierra:         "3572efe1e0741ee5b1f3cc0499325ae59acec5f9ab44df5987bab22312d9e3af"
    sha256 cellar: :any,                 el_capitan:     "00f7047e5d884dbf22ed036154961b41d4ad6ae8295c55043929b008ae82a9f7"
    sha256 cellar: :any,                 yosemite:       "a1315eaaaf667f7486deb2b899c422e3cc9caa8f9e771221dca12b0ecc085dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98180bd55bee493621155475e77ba5de249c1ce27f85edc895a69c9d41a63df3"
  end

  depends_on "libogg"
  depends_on "libvorbis"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/vorbisgain", "--version"
  end
end
