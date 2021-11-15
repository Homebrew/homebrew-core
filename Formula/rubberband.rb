class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-2.0.0.tar.bz2"
  sha256 "eccbf0545496ce3386a2433ceec31e6576a76ed6884310e4b465003bfe260286"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c6b5dcb4e7c5fac379c889c84d143f7ce4bd4c49c0375537bd6577b131d7cbed"
    sha256 cellar: :any, arm64_big_sur:  "25b12c52bafa177daf7a6a3749fe08f4f583af48b534507c7efb723c3a7c1e60"
    sha256 cellar: :any, monterey:       "3c2944cd07b0ba324b18451fcd399b2c34784695f04cfde35b2b1a7711561608"
    sha256 cellar: :any, big_sur:        "b2095039d438fd4b4d8aea05b12c0c71fb1e9ddb4d22c5f3f188bbe69de48c9e"
    sha256 cellar: :any, catalina:       "3acb8683266402608cadf5e2f97ac0b5fd234be2528f1b2ed8c870cb47d56faa"
    sha256               x86_64_linux:   "4b404f33017d438c41afa12b2fccaaecde3e2b96d5644682adc6950e0dd314e4"
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
