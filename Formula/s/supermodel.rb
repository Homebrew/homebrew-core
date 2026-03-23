class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260228-git-d6dec3d.tar.gz"
  version "0.3a-20260228-git-d6dec3d"
  sha256 "4b99ca451379436ad284d682c6849a925d8810daa229271be2e63d24c0cf340b"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0371f7d2f4c880a1cb0be485e0cce84256540a1000d203cbf0cfccc3dea7aa79"
    sha256 cellar: :any,                 arm64_sequoia: "f7e3f881dfc4c4010bbde38779f7b28ff9ea53d8ea623d07a935c39e6e1154ca"
    sha256 cellar: :any,                 arm64_sonoma:  "e4e7f42b1a731d17984fb9ffa48e02e5439280e625ecdf50da9566482f1dd54d"
    sha256 cellar: :any,                 sonoma:        "cd2c90c6b7e2459b867b92476255d138093871804c562b2455e97405b88878b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5c42ecc38e0cf4ccd479739c8f33a20e1feb0689530e552155bb956a6bb95c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f47cc3b5ada785aeabd68913e9bab259ec7a3af3ce6715e512b9173e91e81b"
  end

  depends_on "sdl2"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def install
    os = OS.mac? ? "OSX" : "UNIX"
    makefile_dir = "Makefiles/Makefile.#{os}"

    ENV.deparallelize
    # Set up SDL2 library correctly
    inreplace makefile_dir, "-framework SDL2", "`sdl2-config --libs`" if OS.mac?

    system "make", "-f", makefile_dir
    bin.install "bin/supermodel"

    (var/"supermodel/Saves").mkpath
    (var/"supermodel/NVRAM").mkpath
    (var/"supermodel/Logs").mkpath
  end

  def caveats
    <<~EOS
      Config, Saves, and NVRAM are located in the following directory:
        #{var}/supermodel/
    EOS
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end
