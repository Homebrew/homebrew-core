class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-4.0.0.tar.bz2"
  sha256 "af050313ee63bc18b35b2e064e5dce05b276aaf6d1aa2b8a82ced1fe2f8028e9"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "65ba1e050a7368f043369932bfc493de4f33f9dda9f6863250960559b5bdf1d8"
    sha256 cellar: :any, arm64_sequoia: "5ac29718f68b181de61e81dd42bc85cc74cb1fc4ed5fdca541a94224bc43feaa"
    sha256 cellar: :any, arm64_sonoma:  "d510bad14f78b8a3e7be16f5c49a78fb3638f686ec1c04c2cb28310b49e4ead7"
    sha256 cellar: :any, arm64_ventura: "066c9310bb2eb10817aa44bc17eb1a3ce20f47b4c66e4381b097c8625caef7ff"
    sha256 cellar: :any, sonoma:        "3bcd1310c98256b7a382f3b5bbdf1e22a060bb41989fab028122e0b5cd87e6af"
    sha256 cellar: :any, ventura:       "d2b9fac38088ef6014be7d725f07b5d16aa92e22b1dc56046aa2390005379194"
    sha256               arm64_linux:   "a39402bd21e74bcd13aace129f59aa365409a63b26112d4bc782bef838d11aa8"
    sha256               x86_64_linux:  "982c2036c3528e0ae338680ba6baff4e8a0cd5ee16a2bafe4673e9cdea4d9e05"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "fftw"
    depends_on "ladspa-sdk"
    depends_on "vamp-plugin-sdk"
  end

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
