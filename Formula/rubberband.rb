class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.2.0.tar.bz2"
  sha256 "7905a9516b5b2138d28ebcab978e7cae3558670d096f812c9688813752e3c119"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "22172e690033abb29e48a440db401433c110ae09f4b0632f28c4397a839b5089"
    sha256 cellar: :any, arm64_monterey: "fe6363f0a2cc447e10c819e1c7bac33ccbb5d5bfb0a239eb8573e4d55ba28b3f"
    sha256 cellar: :any, arm64_big_sur:  "640bc828d90f53d0a369a4018fb85e613f2af25da4e38a63713db78682967c1a"
    sha256 cellar: :any, ventura:        "97aa5feed6c72107a20bb7cd76ff58e8f04b19247121bdd504cdbf2be3304029"
    sha256 cellar: :any, monterey:       "4ae7e36ab409a31df353cabb0f517161a4455740b94233bed5aaeeea51a8485d"
    sha256 cellar: :any, big_sur:        "36da34e200b63614206089168a021a93499377360b13ed6ab663b86a594b70c3"
    sha256               x86_64_linux:   "2f8993fef124b04bd00f9bdc6ab5be15a3956f7f00e7c690e3201d1879f4d5fa"
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
