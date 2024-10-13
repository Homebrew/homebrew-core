class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.3.0.tar.bz2"
  sha256 "d9ef89e2b8ef9f85b13ac3c2faec30e20acf2c9f3a9c8c45ce637f2bc95e576c"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "0dbc4dfca618f3b7772772a96a267cf39e8a81f2da4e369d11faa47d2892a857"
    sha256 cellar: :any, arm64_sonoma:   "83e5b2a1828926769eb43c37b1ed95fc6acb52b7b80717c628248ba06dcc4b59"
    sha256 cellar: :any, arm64_ventura:  "206c609c7172b67789074a7cf6d7f488754c36385c8fa192be5b7d79250baa9f"
    sha256 cellar: :any, arm64_monterey: "b5f0bd10292d5ae466dbd52a08675add720790e38844439fae7539fd90ac8ab3"
    sha256 cellar: :any, arm64_big_sur:  "bb6f008e5ae2b65ddc195607d321fd533fcf99a0a0e3e4438dc1f960fbf9a11f"
    sha256 cellar: :any, sonoma:         "6b10db46321e2be0e9925e568ea4d6877aa160b14ca1c3d57bedb0a75c417ee3"
    sha256 cellar: :any, ventura:        "b4650ed709c4c90115f039c4b0d7ad0261a68894a509607d09f1eea066f97884"
    sha256 cellar: :any, monterey:       "97ea0bae9d8ff2f4b0fd8ca64f7f1a12497f1b4c24929b39f02d5e5081da3980"
    sha256 cellar: :any, big_sur:        "7092e475181f31763ba9c7b86d00cde1913357543eb2ed3759b696e7add68650"
    sha256               x86_64_linux:   "be989026114a7f007ae1d5dba0ba2f98bb47da7b3023ff60f4d873f1d45a1bc5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "fftw"
    depends_on "ladspa-sdk"
    depends_on "vamp-plugin-sdk"
  end

  fails_with gcc: "5"

  def install
    args = ["-Dresampler=libsamplerate"]
    args << "-Dfft=fftw" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
