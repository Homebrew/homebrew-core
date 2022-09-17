class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9edfc17be097b8ae7741ddee5d34b5d7c581a98c58e9c565cce34556639161ef"
    sha256 cellar: :any,                 arm64_big_sur:  "f7d948bc4bc997329cd35f2ef6da417577a928a56241ef69d1e12f77a68f30a5"
    sha256 cellar: :any,                 monterey:       "453f0d46ba72d4a83978a34ab8ec0c91e4a4704d07f2bc99e0983d7743d952dc"
    sha256 cellar: :any,                 big_sur:        "924b191728e113ba1894fe0eb14980f41cdac32ba13f47670a1629d8ab7a234d"
    sha256 cellar: :any,                 catalina:       "3075e15314703e3b5c9057a876677b42792ba64278b0b450a28735e795701d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae857033a9b5eef278e3dea57f5e786806c1195df92240432d328852587be2f1"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Applies Eric Wong's patch to fix device name length in MacOS.
  # This patch has been in a "potential updates" branch since 2016.
  # There is nothing to indicate when, if ever, it will or will not make it
  # into the main branch, unfortunately.
  patch do
    url "https://80x24.org/sox.git/patch?id=bf2afa54a7dec"
    sha256 "0cebb3d4c926a2cf0a506d2cd62576c29308baa307df36fddf7c6ae4b48df8e7"
  end

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
