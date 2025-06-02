class SevenKingdoms < Formula
  desc "Real-time strategy game developed by Trevor Chan of Enlight Software"
  homepage "https://7kfans.com"
  url "https://downloads.sourceforge.net/project/skfans/7KAA%202.15.6/7kaa-2.15.6.tar.gz"
  sha256 "2c79b98dc04d79e87df7f78bcb69c1668ce72b22df0384f84b87bc550a654095"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/7kaa[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "b2d889d8c50a32132e8a843b6e11fb74f2201d8b8a5518b0e05494c425c3d38b"
    sha256 arm64_sonoma:  "e041776b87a11f71a2b25a732df463a85965a7a9730a6fdc86ead47b88269250"
    sha256 arm64_ventura: "5cfe334ad3d1727e92bc7c5cd43da8bd89f64b33212ee903bd3bb88946ae6b6b"
    sha256 sonoma:        "190571e9d1291c690b91c25523469fb56448e458d9271b5927b5f6298a3901be"
    sha256 ventura:       "0e4c24744884c459603a2fef964656acd72f417d20eb66582c58ad2c73b87cd7"
    sha256 arm64_linux:   "fb3a76000690803f166042bc610804309c8cef5873a8e45005c4c84a529343c9"
    sha256 x86_64_linux:  "2309306fa67efdf1de1e05fd01bb50448f9f1ca9b6688ed9ede4cd826fca877f"
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
