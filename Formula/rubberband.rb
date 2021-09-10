class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.9.2.tar.bz2"
  sha256 "b3cff5968517141fcf9e1ef6b5a1fdb06a5511f148000609216cf182ff4ab612"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "effbebb6fa0c2fe0ae0dfb034b7f583691391accf39ead4ae0f9a2933cfa747a"
    sha256 cellar: :any, big_sur:       "6f8eb3495c3ab95737df9fd81ae7df3ecb122ebc7468df79049ef2b1fd363375"
    sha256 cellar: :any, catalina:      "29fe97d7bb8bb2b23c2409d2465e56ea84326e9568dbcf6533b4bf4aed52b400"
    sha256 cellar: :any, mojave:        "af62a07fc9604c1df76d654b662c949d75a4d4cb52171aa72fb911e8af533aed"
    sha256               x86_64_linux:  "08e7e6cff8618bd5b8c525d82ad2ae7f564d057db01c0b4fce6a172106b8927c"
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
