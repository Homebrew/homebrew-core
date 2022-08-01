class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.0.0.tar.bz2"
  sha256 "df6530b403c8300a23973df22f36f3c263f010d53792063e411f633cebb9ed85"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any, arm64_monterey: "5e69d82b8ac49175b0d5f7ce7cd144cf5ad0a1a53256ec3d320a88e049f519d4"
    sha256 cellar: :any, arm64_big_sur:  "fe47590afe376f2f7e1b24a239a5e4947534d8425e97c42a3a34b30d343f3d02"
    sha256 cellar: :any, monterey:       "ff93a71a132ce14e836d9f3d80d430ef41c39470da40d4088d3d8d3e58cf827f"
    sha256 cellar: :any, big_sur:        "b02d05078216b43fe33e2b1354fd8a67fa5c3330f893480ccb3bc2b6bb9880f2"
    sha256 cellar: :any, catalina:       "b73a156422b447a2c5a9426abbc70e58e97b0bb644080849e796d8ddbbbab630"
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
