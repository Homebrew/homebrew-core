class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2026.2.0/scummvm-2026.2.0.tar.xz"
  sha256 "4e10ed977daa36780c97a9b3bd7c124842f5ed9b0bfea4e8e35eda4658fa60f3"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "28eae45fe254698e495155987803cfa9ede667682124f4dbacdb16da91b5ad18"
    sha256 arm64_sequoia: "8259d58dea5c612c26ca91df72076be7406acf3c97306748549d4ed8073ea90c"
    sha256 arm64_sonoma:  "94ccc195af9ff92fc84716c29969d5feb73b1980bbbeb9db93080491a19ac302"
    sha256 sonoma:        "a37ea7f4b0d16ce19305f73e9ae3ee03e59861237325ccb3d813429458550103"
    sha256 arm64_linux:   "cbd5dc269a1630d9123fc72ff7574e91c7c9f0a74ec23087af2eb9867d32c486"
    sha256 x86_64_linux:  "fa38ba1ba6f25288be0d34df59acd0a47b6ef8f805f132efd29ea7504d1ed8b4"
  end

  depends_on "pkgconf" => :build
  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "mad"
  depends_on "sdl3"
  depends_on "theora"

  on_macos do
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--enable-release", "--with-sdl-prefix=#{Formula["sdl3"].opt_prefix}", *std_configure_args
    system "make", "install"

    rm_r(share/"pixmaps")
    rm_r(share/"icons")
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end
