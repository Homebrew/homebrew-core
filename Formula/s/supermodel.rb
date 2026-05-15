class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260506-git-9c9e7b7.tar.gz"
  version "0.3a-20260506-git-9c9e7b7"
  sha256 "74a6310ebe080b1de08ae92bbe6b4f5ca73babb7ef184e90b23079700133b710"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "acf16b3d615cef9aa94cd26e0a5ddc5c855453849484ccf8f50d19ead6e70e15"
    sha256 cellar: :any,                 arm64_sequoia: "0fa184087dae96b7825269d7fa0c22521030172f02cb38b6d3f60eaeadea4e3f"
    sha256 cellar: :any,                 arm64_sonoma:  "c1bf21115566f1ac068b51949a762526e7d4acc5e88a6430deeba27886821122"
    sha256 cellar: :any,                 sonoma:        "2ea25164409f2a1cd59c6e64b3915b98e4f066248019bad63e217f0ef8af1248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c01e14c0679bfd75640f4f4b6d91c5a01a7c5c5424d5fa3e7250af0a516f989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0565487f846c020248075c50867c18c76f99d35351d1258f7ff7d04f62b4a7"
  end

  depends_on "sdl2"
  depends_on "sdl2_net"

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
    inreplace "Src/OSD/SDL/SDLIncludes.h", "SDL_net.h", "SDL2/SDL_net.h" if OS.linux?

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
