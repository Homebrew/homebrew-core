class SevenKingdoms < Formula
  desc "Real-time strategy game developed by Trevor Chan of Enlight Software"
  homepage "https://7kfans.com"
  url "https://downloads.sourceforge.net/project/skfans/7KAA%202.15.7/7kaa-2.15.7.tar.gz"
  sha256 "2a9833ffe5fa7558857d4f8ba39cad1dccefadb01d298350ed8f954c75b6a6ae"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/7kaa[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ff7bdbd3a2e4e637a6f90dd9d95051baece154f4abb30ddbb88e4a4a8b84cb24"
    sha256 arm64_sequoia: "8e23d82f2fa267b2489c5be9f53f9423de28209db8c691a8e55ec97bba8e4879"
    sha256 arm64_sonoma:  "5f12722cd8c266303787d1d39e58de4703b009c17b082589aaf15414e5a163a4"
    sha256 sonoma:        "cd1588f31d2e72b42fb11b76f1ed6b10dc0340fe0021c3e26359fbd22c66e3d2"
    sha256 arm64_linux:   "5ec481c6ff98179854ef137c1593f24225766e8670b50af3a2922cb9af683be5"
    sha256 x86_64_linux:  "0219b6986caccfd218784b94b28717301b9c3a1bb278093b12d8934f843c881a"
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
