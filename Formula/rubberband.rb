class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.1.2.tar.bz2"
  sha256 "dda7e257b14c59a1f59c5ccc4d6f19412039f77834275955aa0ff511779b98d2"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "39ed0d04fc654ebc89f2819510ac5cad990a5b5c7ea2657cb38813c3ed41ba30"
    sha256 cellar: :any, arm64_monterey: "ac1818bde00e42888ea13d151de85e8b387d6c6107df617ac24edf53ca6a9ded"
    sha256 cellar: :any, arm64_big_sur:  "31a26e4d2c2f37af5f5347dad63b7e1264d0e69d607639e559b1a8f45b554a93"
    sha256 cellar: :any, ventura:        "36de6f9a470b303f83dfdfbfde201ff02f38bf499407aac23d7eeebab42c3c68"
    sha256 cellar: :any, monterey:       "84b15332391d9e870603dd31300db0b639cbde59f891e3e78b943e2d03dde0c9"
    sha256 cellar: :any, big_sur:        "39d08fc2a284ba173fdb2c97c93cb526b0c2ac17006cd84249c7389b6ee2c85b"
    sha256 cellar: :any, catalina:       "5f22527cc4d85d7b29c55c3e923f097f36d231041507ba75ab7b9669aea57d17"
    sha256               x86_64_linux:   "9e50f245e3e1f7434390faac68adb7c306bb498845a30218f744fd0fbd238c0f"
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
