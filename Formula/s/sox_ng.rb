class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.6.0.4/sox_ng-14.6.0.4.tar.gz"
  sha256 "faf376b7054eac6da3c6c15897a42a8fd22147d5d5ea05921ff1afa1f4e7a7ab"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d71a82586784fca8f39ffddd4f4bafc1f2f4ec00804999658aaeabef5ceb8a05"
    sha256 cellar: :any,                 arm64_sequoia: "ef0c00d04f83842b9edf92aaee3eeab41227d15b6de9850e5f0fa8245aa8a155"
    sha256 cellar: :any,                 arm64_sonoma:  "61c54bcac65f22b9301bc5cd0dd1e8473dcb9dbb1f38ce6d24e62bec16b479d1"
    sha256 cellar: :any,                 arm64_ventura: "2d151503ad1b08204140a3cb8c21bd3f8f6aee89b36724e3f0f8e02d356c508a"
    sha256 cellar: :any,                 sonoma:        "fe18c65c1616e6669bc19e8fa3aeb875151401cc896d99b42e3dceb8cbaa8daa"
    sha256 cellar: :any,                 ventura:       "f32fa9425d8ee7bf73e1e5dd059efc3dd1c04548b86829775009c7cc0885412d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1c76e54d4f61ae88a9d68e98b1327eede12e9bc182b0fbdc91602b499def0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf84d712d160f16f36550a01fc8ba7e3e910f74f73e92643cb1fc76bba5a74e"
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

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
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
