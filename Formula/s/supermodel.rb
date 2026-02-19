class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260207-git-fe00551.tar.gz"
  version "0.3a-20260207-git-fe00551"
  sha256 "bc74409ae14ec4f37e6bf5756ec6b6881f8c3c61bf3ef403425a3d8e86337769"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd46c2ada7bef0526ba1c8c5f77e41421a181e7abcbeb1152312578d87600e4f"
    sha256 cellar: :any,                 arm64_sequoia: "69b2f00d8e9e8a7c4081da1be8b10b588e9f84374293752c6bd29158e034ca57"
    sha256 cellar: :any,                 arm64_sonoma:  "87ec43a75057a0fec645785bb9c97d24271bf6d9a43b39af1ddb768ee50e2503"
    sha256 cellar: :any,                 sonoma:        "be64da4ac04c3093d4cb2ae8b084b532096f501fd4d17c459516901d719a8e9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b314b30bf69984062bef18d9d2ce9271127038cf8f9c31dab176992a5c6c4e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "155998a85cc992ecd6549c7b948eb3eac2cf861d7f80d7419106968cf413b08a"
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
