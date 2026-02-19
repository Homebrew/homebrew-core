class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.9/sox_ng-14.7.0.9.tar.gz"
  sha256 "e69be36f0c843d7f7f21c0abb6526d4c71c348868eddc014be346ffbb7cd683c"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec6270ecb1577a587ee744204beeb1a749e107c2757e5a172fd8f26655210f16"
    sha256 cellar: :any,                 arm64_sequoia: "d8e0aba457ba94f313c1a868c0f87eaa0ee2216b9890b29685a122c870fa5c73"
    sha256 cellar: :any,                 arm64_sonoma:  "be65b4f861bdd1496e47e9aa648e679395f5cc9d6458bbb446ed87a4311c5348"
    sha256 cellar: :any,                 sonoma:        "328cf6f0f545c4f640855d079fc1b04072e87e46ac1a639ee82b0fbaede524c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa96a4f81ddcbdcda3de1812edb055b814484c9deb1b5ec07638360a947cf600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c087a10584c929356b626b71edbdaf5eb275da456ff2765f2c923c95157602f"
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
  depends_on "wavpack"

  on_macos do
    depends_on "opus"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "sox", because: "both install `play`, `rec`, `sox`, `soxi` binaries"

  def install
    args = %w[--enable-replace]
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
