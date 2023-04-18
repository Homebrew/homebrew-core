class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d5679ccdaa83932444058e30d202a04d59608628bd205a912ebdfaf68c334ff8"
    sha256 cellar: :any,                 arm64_monterey: "10012939e3d82a101d7d100e74885234426fffa599c6b22787b7232428f8a6f5"
    sha256 cellar: :any,                 arm64_big_sur:  "ac3d90255b09e71f6c6d3f48a8f744ad5b5ad38b8494c07a6d8d4db91cb64d3f"
    sha256 cellar: :any,                 ventura:        "56e05c43dbd0c01b828ed9be01ca8b4b9a51efabd5315f2bcb8467d6ed620688"
    sha256 cellar: :any,                 monterey:       "0325437ffb26d7b3d8c5c735eed402b2a95a471f4a8e72eeb9e5fa2416960f8f"
    sha256 cellar: :any,                 big_sur:        "76b3510fa79c9580b3005792945479fda775c6f93ff69236192c97411b50d715"
    sha256 cellar: :any,                 catalina:       "4caec734b381cd22924f520609bcef9ec6c8a7d65fa8c0178a57b65e00d0f633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65355303a0a12e941de780677215639938e6d5909af3b956f96192d927f77824"
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
