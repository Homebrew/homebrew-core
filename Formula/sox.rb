class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 3

  bottle do
    cellar :any
    sha256 "fc412be07e577c2161763dfb509f4fb43f4fe3bca206a1b0b370687df0a264fa" => :catalina
    sha256 "4906207f83bd0f4ea1a67d040891711e9a9e8830216e451072f2957ca566b83d" => :mojave
    sha256 "c0bb4ba7ec922d9a8c71c2ba84e28c66c67e4fdeae970011ea45e937f43c18bd" => :high_sierra
    sha256 "dc8c294bb96c0b7ebc3ade73476c6031664bb8e81a32ece87ce84f815deeced5" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libsndfile"
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
