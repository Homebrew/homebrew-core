class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 6

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "c2956a28433c90329ae94d2b2484273e252b14ed3fa4cba0e2b2742da3332cbf"
    sha256 cellar: :any, arm64_tahoe:       "5e75dafeb3b3ee98d3fec57ddc6c7910b5c2af77de692062c90dd9e37282e592"
    sha256 cellar: :any, arm64_sequoia:     "e7628b40fc8bef9273a2f7632cfc27ec34c8a6da03f3b59696992216d8f8e0aa"
    sha256 cellar: :any, arm64_linux:       "57c25cb3b88b99ff56f11748d53a013e643865d4c074bd889b7abc6bd605d041"
    sha256 cellar: :any, x86_64_linux:      "4f86b9ae7a1328854808e51516e92fa6b3d6c5a3823e8528669dfedf10882c87"
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
    file "Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    type :unofficial
  end

  # Applies Eric Wong's patch to fix device name length in MacOS.
  # This patch has been in a "potential updates" branch since 2016.
  # There is nothing to indicate when, if ever, it will or will not make it
  # into the main branch, unfortunately. Vendored as 80x24.org no longer serves it.
  patch do
    file "Patches/sox/coreaudio-device-name.patch"
    type :unofficial
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
