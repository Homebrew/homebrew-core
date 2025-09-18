class SevenKingdoms < Formula
  desc "Real-time strategy game developed by Trevor Chan of Enlight Software"
  homepage "https://7kfans.com"
  url "https://downloads.sourceforge.net/project/skfans/7KAA%202.15.7/7kaa-2.15.7.tar.gz"
  sha256 "fb85ac682f86edd8ccf14667d652413ba222cd0f45b80b2a00c49a0d69dcfe19"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/7kaa[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c417b3401b46d6a4e296e85cea8a5626aa12395472b0c67b439e7f0619f9ebb"
    sha256 cellar: :any,                 arm64_sonoma:  "c1817e2bb2ab004f2c2341529a1720a239278a56fd94f05ac880e4d6aa4be246"
    sha256 cellar: :any,                 arm64_ventura: "12bd271b2579480e3276b9c8be1733f32fee512501e9f55074201e469b136ff0"
    sha256 cellar: :any,                 sonoma:        "ad1efe7266f03ed91a43f0e833a007786f6a34a457eeb7dc98b8b042aa191db2"
    sha256 cellar: :any,                 ventura:       "f9c1cec7f7383dea031f30c397bf3e367d3f1ceeb187c49af68a59da4fb23064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033abf2b0c1977d097fc4d579e6ac870f5cda99949f162ce60e8e887cf7749c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1c81bcf8a4908b5c583cdb408527def7468a614ab368e16b495c576dae30fc"
  end

  depends_on "pkgconf" => :build
  depends_on "sdl2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "openal-soft"
  end

  # Multiplayer support requires -mfpmath=387. Otherwise it is automatically
  # disabled, which also disables `enet` and `curl` usage.
  on_intel do
    depends_on "enet"

    on_macos do
      depends_on "gcc"
    end

    # FIXME: `uses_from_macos` is not allowed in `on_intel` block
    on_linux do
      depends_on "curl"
    end

    fails_with :clang do
      cause "needs support for -mfpmath=387"
    end
  end

  def install
    args = ["--disable-silent-rules"]
    args += ["--disable-curl", "--disable-enet", "--disable-multiplayer"] unless Hardware::CPU.intel?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = spawn bin/"7kaa", "-win", "-demo"
    sleep 5
    system "kill", "-9", pid
  end
end
