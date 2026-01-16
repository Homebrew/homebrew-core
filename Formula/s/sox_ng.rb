class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.4/sox_ng-14.7.0.4.tar.gz"
  sha256 "399740e1a16b9eea1285c80c3dbd0c5e2abcf3953327447cc90baa1abea8bbe2"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a5388a7188de5071f9394995c9d4dc5196608331ed3bec1dec2585aad841616"
    sha256 cellar: :any,                 arm64_sequoia: "13895a608e19c78331f53711bedb29291391c9f48896137cc31717142cd6eca6"
    sha256 cellar: :any,                 arm64_sonoma:  "7e2958541e6883f373f5a2e52273595200076bf34fecb9d5e903d93cba1b3d5e"
    sha256 cellar: :any,                 sonoma:        "134c62ba5cf92c3f67a5a0af87670ce35296b046632bbab05580c21c96b78f30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dfcfcefe8df595f5821bcd4d64e940a76d3a93b5d97ea5affe144a814b79a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7001d47c0e298dd52bec0b7f3e3bd3c9d00d7cb9866ba61c4f345af33d48d478"
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
