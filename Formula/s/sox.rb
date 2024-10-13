class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "87d0fedd63d061dcce9a85a218415c57301aa6b7d0a2846c133b8773ad730b7c"
    sha256 cellar: :any,                 arm64_sonoma:   "15d7b75e38dbcf26b77356f79a1c184293bf664521098254f8279f417fe6ed9c"
    sha256 cellar: :any,                 arm64_ventura:  "1669b614365ee6f54c3b974aa2e25c6e88353caeb73a2763f31c5f71d7032705"
    sha256 cellar: :any,                 arm64_monterey: "170cf704ff002b6d97b5c5f081e3dda5d87a9860860a13b1e8a7efbb4b4dba53"
    sha256 cellar: :any,                 arm64_big_sur:  "ac3d7cf23b479a1bf067f82636cd5345d2e43de29e57d687206922c8d260ee9f"
    sha256 cellar: :any,                 sonoma:         "1b5e546c0a5bf131dfa78725e1c607257041f6d3642fbf5788cfc28344654c91"
    sha256 cellar: :any,                 ventura:        "54d7c86a22ce014e0924791450e8c8a2630fc2609f5086d1620bfd1fa901544a"
    sha256 cellar: :any,                 monterey:       "dec8603f276fe6a1928a320ff498267785b75fcfa9523647de2f623367d2e896"
    sha256 cellar: :any,                 big_sur:        "bf59b93291ad51588e8e4183165ee8d945cde82f0ea22ae61e1c5076a5be10f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bb06054835fa3a2be758935d05d245b9edb5330b484b6f1e57d77ab60f772ad"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"
  on_linux do
    depends_on "alsa-lib"
  end

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
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    args = std_configure_args
    args << "--with-alsa" if OS.linux?

    system "./configure", *args
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
