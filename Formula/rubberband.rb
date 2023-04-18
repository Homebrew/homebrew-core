class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.2.1.tar.bz2"
  sha256 "82edacd0c50bfe56a6a85db1fcd4ca3346940ffe02843fc50f8b92f99a97d172"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d2ea5c9b03b60520fecbb523241fed202fa029a93099ba85d1ee6fb073757e25"
    sha256 cellar: :any, arm64_monterey: "4fe8cc4990cbf3654d742e7841c1c8767a71df642f16d49e1f2717700940fad6"
    sha256 cellar: :any, arm64_big_sur:  "7e7eaf72e4431ceb12da08f04b769c8a103b138590553d13260bc137551a4a39"
    sha256 cellar: :any, ventura:        "ae6ae456480a2ce1ddfc195b52468932932e09b31838b723216c6281a5e876fc"
    sha256 cellar: :any, monterey:       "7c20243ffd717a88b55f5e61bdc8e8690b19fbc775747485be088f31500b2e02"
    sha256 cellar: :any, big_sur:        "ce3177feeb22218844ff84a4318dae673122f721e706954d56b884e5ac058632"
    sha256               x86_64_linux:   "320d8399f3fa0ead92892cf4905207b2d1b0572c6cd654ea662198cf1c82c2d5"
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
