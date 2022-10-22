class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.1.1.tar.bz2"
  sha256 "a442551fe7d26fb4a54dd1c34178733dc9c76ac9ce051a02325f5cb35d154381"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "3935d034c124ca2e208173635ccdc395d11e4e80f908c4cf76b089d1e61e5047"
    sha256 cellar: :any, arm64_big_sur:  "a636f9233b3c92c2385dcc6cdd63e69f931758362716bbbf3f932a8a5483e025"
    sha256 cellar: :any, monterey:       "aac53b3162aaa30be4101651cfb290c0485d08acb2dfdc567cad52d161441f98"
    sha256 cellar: :any, big_sur:        "07bdee9696a48269d55018409af7716ea083b4bf033644de6054c7b0b1a06516"
    sha256 cellar: :any, catalina:       "3c5e26d5b78b67fcb8db228dc2d0c6846920c76127f5798cfcc264738b5ebdb5"
    sha256               x86_64_linux:   "5a045984bac7b8318f1f222c44605370e5a97ec24768dc64cf29d7a46cdb424c"
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
    mkdir "build" do
      system "meson", *std_meson_args, *args
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
