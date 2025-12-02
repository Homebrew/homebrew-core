class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20251120-git-3e94dd0.tar.gz"
  version "0.3a-20251120-git-3e94dd0"
  sha256 "e6d6d5c7576fcf8c3ce2cfeaa2697850b69a420d647bf5faa7bfdf4cdae00068"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c357302f522c01c1cd3f4677db6ee5d32f81346c01a6b137247234be28da219"
    sha256 cellar: :any,                 arm64_sequoia: "3ea589078922c6e1e5bd80b4be48a912b45c772efcbefce5a3117ec87a9cb9ba"
    sha256 cellar: :any,                 arm64_sonoma:  "5ab7b43e0bc8d5dab7f12ed48e66de138a50f53245cd226150db09644ee42b5f"
    sha256 cellar: :any,                 sonoma:        "7c1694d84eacf714ef16a0ab98650f77930bd3eed82b65127022675179201739"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfcc683bcdea6bc14ba2a362aed404ad650d45d1d7286677336ff873339714fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2975264ac03057937a26a48503c67aad2752de87a06a9122f257808ef45b7742"
  end

  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
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
