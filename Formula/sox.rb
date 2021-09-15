class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8070949420a9a02f3d5e1a99bd460d064e34c361798bae5c4554ac8e1aeb2d49"
    sha256 cellar: :any,                 big_sur:       "e3f62a35b06c9e79516f575a923b3aafc5357f370f4ae5c2812c67c8862ae11c"
    sha256 cellar: :any,                 catalina:      "fc412be07e577c2161763dfb509f4fb43f4fe3bca206a1b0b370687df0a264fa"
    sha256 cellar: :any,                 mojave:        "4906207f83bd0f4ea1a67d040891711e9a9e8830216e451072f2957ca566b83d"
    sha256 cellar: :any,                 high_sierra:   "c0bb4ba7ec922d9a8c71c2ba84e28c66c67e4fdeae970011ea45e937f43c18bd"
    sha256 cellar: :any,                 sierra:        "dc8c294bb96c0b7ebc3ade73476c6031664bb8e81a32ece87ce84f815deeced5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "812ddfd499335d3ff3e096b6153ef60e86326b5fb2cffb3e2ae02e8be6bc98c2"
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
