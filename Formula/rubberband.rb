class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-2.0.2.tar.bz2"
  sha256 "b9eac027e797789ae99611c9eaeaf1c3a44cc804f9c8a0441a0d1d26f3d6bdf9"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c58fc2b2d0bae9614691265796e2ab6c3948d89b07a33fc655447c93a2f237ed"
    sha256 cellar: :any, arm64_big_sur:  "0bc3ea2fa1380e28d60bc3f594a0b247e35e811cc2db989b6a2d1b31f7792b3d"
    sha256 cellar: :any, monterey:       "ba0cb5450322e0ddb291105fd41362e3566c8428afccd480ab0f15b63b5bb0c0"
    sha256 cellar: :any, big_sur:        "79e5052df8efd17288a9f026930a304f9ffe32de60e28af443311deea5c05e54"
    sha256 cellar: :any, catalina:       "51f10e60f0ef221952e30667428236d811b51aacd663c373fb0af4dece854c89"
    sha256               x86_64_linux:   "3a3b64b35a231daf0faa45d0cfe37a9b1ef092013441191bb77eb9f59c05fac6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "fftw"
    depends_on "gcc"
    depends_on "ladspa-sdk"
    depends_on "openjdk"
    depends_on "vamp-plugin-sdk"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
