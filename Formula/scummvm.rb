class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  # TODO: Update license to GPL-3.0-or-later and remove from
  # permitted_formula_license_mismatches.json on next release
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  stable do
    url "https://downloads.scummvm.org/frs/scummvm/2.5.1/scummvm-2.5.1.tar.xz"
    sha256 "9fd8db38e4456144bf8c34dacdf7f204e75f18e8e448ec01ce08ce826a035f01"

    # Fix Apple Silicon build: ld: unaligned pointer(s) for architecture arm64
    # clang: error: linker command failed with exit code 1 (use -v to see invocation)
    # Remove on the next release.
    patch do
      url "https://github.com/scummvm/scummvm/commit/7003cf793f2ddc5b773293088a2b5e485bc8c105.patch?full_index=1"
      sha256 "616fd3c2e8128c0c4c9d7bb56622f0abc27a101bc45cc7d2d79078d77cc03dbd"
    end
    patch do
      url "https://github.com/scummvm/scummvm/commit/6791dc23196cd71d09ecc44c510c6dd35a3f0787.patch?full_index=1"
      sha256 "45c6c6e70a3bae70d02b09f139d9f47cafe561524dfff9939c0e5bd63f7386b2"
    end
  end

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b6b391ced65420fd092e0145c8a8db889e8476502bf76b89aa1c1d68e02a0249"
    sha256 arm64_big_sur:  "af380525ea154276ad0d373bf6118f3a6838113cbeb9968902ae338cd25cf3c4"
    sha256 monterey:       "d05447bbd2eee2531f7adf1b37f52a70a839b306df931e2abddffb833918b534"
    sha256 big_sur:        "64322552466bf84d7c908349c1d3b2a9033c0f296d654732fd23dc09e37ce556"
    sha256 catalina:       "f4955d7d9be4be813bd81ae4e1895307f97f52cc8af5df8c99c61356cc42cb5a"
    sha256 x86_64_linux:   "a84d8f59c66e8a3f8556909a6086e00a1afae1c1054b6b1bb7ede2e3b26189ce"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"pixmaps").rmtree
    (share/"icons").rmtree
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/scummvm", "-v"
  end
end
