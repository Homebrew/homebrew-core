class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.1.0.tar.bz2"
  sha256 "b95a76da5cdb3966770c60115ecd838f84061120f884c3bfdc904f75931ec9aa"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "9f00d96a84d991c8495019d2fc21c056dd72d16558bfe2e06550a164883f9f6d"
    sha256 cellar: :any, arm64_big_sur:  "9039ec3b055ecc3ca0dd5e684d514ed9044351bfd37481127d6889dfecefed03"
    sha256 cellar: :any, monterey:       "743e294a7666f6143a9618241f68cd57d4c076bc3babac7bd7cf398e7f5dca76"
    sha256 cellar: :any, big_sur:        "dc0c6f5fc26e945ee35d833347616dd6ccf9792fde584817f89acb1fc9ac1c46"
    sha256 cellar: :any, catalina:       "e088502f67b68433a0c79069a829d7aa738049f9dd56e3477a131d97ae14f90d"
    sha256               x86_64_linux:   "5b35b7c651503c148b1b5c9be0659073191965a8c3c4e1df8d31b2cbcc944bab"
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
