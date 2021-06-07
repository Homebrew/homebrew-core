class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.9.2.tar.bz2"
  sha256 "b3cff5968517141fcf9e1ef6b5a1fdb06a5511f148000609216cf182ff4ab612"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/Rubber Band Library v?(\d+(?:\.\d+)+) released/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b5c746daacac9890ebec61ba76db168a7a43a9ea68855ef0c11e705a94458050"
    sha256 cellar: :any, big_sur:       "f5d703f2e955366c0ad84ef1893e10720b8be81fb58d8df5e7636d4c04952278"
    sha256 cellar: :any, catalina:      "7ccc9bb3c852f79538337c46b9e6fa9aefc7693190c0ddd67fbfba76717c91df"
    sha256 cellar: :any, mojave:        "3d1587253220e488765f4ad6d86cae2fdbb351a539ef9525c4b981d8bd49af6c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "fftw"
    depends_on "ladspa-sdk"
    depends_on "openjdk"
    depends_on "vamp-plugin-sdk"
  end

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
