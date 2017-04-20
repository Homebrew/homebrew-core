class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"

  bottle do
    cellar :any
    sha256 "141d5fa372dc613b99eca761856c61a9b0c6631f06a97d524725e23d9398f389" => :sierra
    sha256 "7c843e5b55d1375f61177452469d8667d135bdbb0331a17e049f67341ad54d48" => :el_capitan
    sha256 "a561041089c0f0ac9eb49df48127ae3bd9769907d92c51443d49edf4da372f26" => :yosemite
    sha256 "c618f6714b9a14fc52cbb6a474a5a11e1e8feb0b45c0238fdb86b51ed7b1c227" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "mad"
  depends_on "opencore-amr" => :optional
  depends_on "opusfile" => :optional
  depends_on "libvorbis" => :optional
  depends_on "flac" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libao" => :optional
  depends_on "lame" => :optional

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
    system "#{bin}/sox #{input} #{input} #{output}"
    assert_predicate output, :exist?
  end
end
