class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260101-git-92bd36b.tar.gz"
  version "0.3a-20260101-git-92bd36b"
  sha256 "161c4e2839f868aa2fc6b1902dc6265b695307f707e6d7ac5bf33470ce184dc5"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d2cb0d6ae05077e13c174b35bf0b4a101a8a7e48307383a81d3b20b20eb9b1a"
    sha256 cellar: :any,                 arm64_sequoia: "3961e310efcf3dbf3ef561cf2622221d523c24eb4e2b7eef75471be97ebecd8c"
    sha256 cellar: :any,                 arm64_sonoma:  "792220f6098163aa0963fc6df0220077a17b5175d8bdc8d6818649f18e722c4b"
    sha256 cellar: :any,                 sonoma:        "ff17a1f0c284bdad3198270da24675f878f8bf25f947f6ed68759a3363bd9200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9d8e33d9fc29c93e4a3e299b3fbeca5233ba532da1be32c508080fbf037aa32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64766d67a967b5269db273bd422eba204b1507f042764a82c25d8f3519a68833"
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
