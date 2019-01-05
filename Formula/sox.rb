class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "e0e0c4d0d52410e04179c4cdca1cd09c46451a282af6ebe7b8840e6b9aac4268" => :mojave
    sha256 "5ba02bdd4b170dc35d5472399a705a13e2711e2e84af79c98b2b484e4acd05cc" => :high_sierra
    sha256 "e7bd73d3b1f15ef439b2cba3cddaa74e3fad91747f2be1f66a551d6db1a61c49" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_predicate output, :exist?
  end
end
