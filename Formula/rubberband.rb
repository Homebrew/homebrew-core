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
    sha256 cellar: :any, arm64_monterey: "a70400b4694acfba6d59576c6854b083b1e1f7c80f9e849eb0266245ad1ff4cf"
    sha256 cellar: :any, arm64_big_sur:  "91d25871f4588a70dc145fbbf92fa8fdb874e43d350001a66f235d537660ec4a"
    sha256 cellar: :any, monterey:       "7b8eaf28f8ce6179e77651b04eba3e578d763e1ba1740381d5032f9f112ebee6"
    sha256 cellar: :any, big_sur:        "ed69e5ffec5c5f5ebbe1557f020b57f188bb320d0c0ca1595f4eaead0f7cbf43"
    sha256 cellar: :any, catalina:       "4f1fd0c9f7fd9870c502b8389f660819197a8b036570d70b16b06db0affd4443"
    sha256               x86_64_linux:   "ab4a2484f146fb67825f2b37ce90c27829d754f854886dc7cf210425c5db9a5e"
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
