class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 1

  bottle do
    cellar :any
    sha256 "850cd95c4baea2d91467637582f120ab9eff066c7414847512ea9cf49ba218f1" => :mojave
    sha256 "f1ba26233464499f58cc0cab34c5472d8b9e30a83cbc6e185b451a9476d560f4" => :high_sierra
    sha256 "de9126013c1bbd7ec728197cc471231cf17c51e7620e995590b8a6ade6c07521" => :sierra
    sha256 "f3b3ac24d351edb82fcd30119f13f6b86848c62b9130b6d20c8538e8b2b17d89" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "libao" => :optional
  depends_on "libsndfile" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "opusfile" => :optional

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
