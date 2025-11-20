class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  revision 6

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "efd1927beadef2b84a6a9840549240134d77eff31208e118f37463f8042874ae"
    sha256 cellar: :any,                 arm64_sequoia: "dd3179a8e7d8399ef404e8e19e199d7cb2d43bc7472cc6e5932777dd204ea20f"
    sha256 cellar: :any,                 arm64_sonoma:  "ec5c73d125f2ac73ddde98d2264a298611f2dd819a873e115178f083216064bd"
    sha256 cellar: :any,                 arm64_ventura: "719011d445046c330686ae5fef7df2561b14c9f966025263bb948b176b528552"
    sha256 cellar: :any,                 sonoma:        "b9caf7383de463f53526e60b33f07792bcbd89a99d358ed76ed91df4ac580b58"
    sha256 cellar: :any,                 ventura:       "a582da3eaee0febd63765341ba7e70fabc57895f7595641fe1565dff40929231"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "526bdf965df84741c4e639c24931f3f03e9b19d438caa735192214e1831d809f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c44da47de6f97f6e1542c5757a01e7aa1dad4ba631d2ae3eb0c24c1bca09a5d"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "sox_ng", because: "both install `play`, `rec`, `sox`, `soxi` binaries"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
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

    args = []
    args << "--with-alsa" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_path_exists output
  end
end
