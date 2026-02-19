class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  revision 6

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7cadfa60a83a3b9f4474f7fad9ce3a98ae3ddf76025ac24a2aa4d4c3c3e6def9"
    sha256 cellar: :any,                 arm64_sequoia: "ac396d46374213381ce1b2f647c642ab11ecb01d9420bca12406b020b66ebeec"
    sha256 cellar: :any,                 arm64_sonoma:  "2ed6611f5c885830d3b666c7705ebc06aade824c01db7c25ff11bd1ed6852722"
    sha256 cellar: :any,                 sonoma:        "80ff50c0e93e0d6230a3905005101338da05bb8775bbd22728e6b886c7766d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d32108a449ba98aed550004ad68815dbf223635e7725a349080060d987d04c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5bc49e8db2bf0f43c4f3a9b47f4b6a5824da8ac31e8988aa244b931aa6531b7"
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

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
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
