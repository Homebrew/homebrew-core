class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "https://kulp.github.io/tenyr/"
  url "https://github.com/kulp/tenyr/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "29010e3df8449e9210faf96ca5518d573af4ada4939fe1e7cfbc169fe9179224"
  license "MIT"
  head "https://github.com/kulp/tenyr.git", branch: "develop"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "594fd49bb4b9498796f617ff227b3524b3d7612e8c3eca557f22cfd1ec0fde0b"
    sha256 cellar: :any,                 arm64_sequoia:  "4067084c37f782e15f3b179f7dedc7a599c66b791e3c0aa013e7dbc8ae804e0f"
    sha256 cellar: :any,                 arm64_sonoma:   "8e373dabed5c34e87d91d2456d4bf011df0ed7d49a5e1eecf21d1dbca6e2501f"
    sha256 cellar: :any,                 arm64_ventura:  "655a2c3c2841cca8dc2a9a12251050701c738425dc78687f2062357ded8bf4a2"
    sha256 cellar: :any,                 arm64_monterey: "9254f0926869364cd952129f192c9fc230ef6a6343e373c1640872bbe9c51345"
    sha256 cellar: :any,                 arm64_big_sur:  "d5b29d7fe175e9d5fa9a37fa80f390b7c0a302b5d8d8d55cf591a394878cfb1c"
    sha256 cellar: :any,                 sonoma:         "d9847884a384e0b167e004c67fed4250131b69620291d924208f1f07e98be419"
    sha256 cellar: :any,                 ventura:        "7174b9cc9538058923d3e8cb74867679cddb2f8d932c644b31af6a1948a3d701"
    sha256 cellar: :any,                 monterey:       "6fd5d63030858e3d238e668643502a954424d6cebc82a15a6a0e19eb13505ac6"
    sha256 cellar: :any,                 big_sur:        "1d65d8a309019393a6db1f4d16d09f6fea293fc23dbb572ffab044cdabd952ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "21cc8e97d6069437c1117ead2fce89372a5251458e8878f58ff8127ce5e52f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5c12c61e48eeb39a813598a9d1723095d0d0aaa5d6b30118457df84ac4f57de"
  end

  depends_on "bison" => :build # tenyr requires bison >= 2.5

  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "flex" => :build

  def install
    inreplace "src/devices/sdlvga.c", "SDL_image.h", "SDL2/SDL_image.h"
    inreplace "src/devices/sdlled.c", "SDL_image.h", "SDL2/SDL_image.h"

    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `...'; ....o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "make", "BISON=#{Formula["bison"].opt_bin}/bison",
                   "JIT=0", "BUILDDIR=build/homebrew"

    pkgshare.install "rsrc", "plugins"
    cd "build/homebrew" do
      bin.install "tsim", "tas", "tld"
      lib.install Dir[shared_library("*")]
    end
  end

  test do
    # sanity test assembler, linker and simulator
    (testpath/"part1").write "B <- 9\n"
    (testpath/"part2").write "C <- B * 3\n"

    system bin/"tas", "--output=a.to", "part1"
    system bin/"tas", "--output=b.to", "part2"
    system bin/"tld", "--output=test.texe", "a.to", "b.to"

    assert_match "C 0000001b", shell_output("#{bin}/tsim -vvvv test.texe 2>&1")
  end
end
