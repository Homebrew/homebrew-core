class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 2

  bottle do
    cellar :any
    sha256 "89c40d6f9fd1c0e081aed9f480a43b77d7c58c1b90ec81f5ca544c1e3b7c7411" => :mojave
    sha256 "38609dce27c7889e851be81af9d0ab83f4cfe8547b464eac4f55d7208f5d4f38" => :high_sierra
    sha256 "f3fae1b9652b4dec7d751e4b7c80a88314621bf967a0d503a91e87d27c4d1d82" => :sierra
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
