class SevenKingdoms < Formula
  desc "Real-time strategy game developed by Trevor Chan of Enlight Software"
  homepage "https://7kfans.com"
  url "https://github.com/the3dfxdude/7kaa/releases/download/v2.15.5/7kaa-2.15.5.tar.xz"
  sha256 "350a2681985feb4b71d20677d1a6d11921b9e3d97facbc94e4f020e848d8ab2b"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_ventura:  "05ea4b89e312f6cced18edea416fcd33e142f10cec22f78ab16adcb94492cd9a"
    sha256 arm64_monterey: "613f58345758d0fd913e9136ab673f6dc9c433165510bacffdd8e004b23cc95c"
    sha256 arm64_big_sur:  "25b48e0d70033d97c5539c1c858d0676a91a40a63027f5f11a8282e17ca7ea46"
    sha256 ventura:        "f8c1a6666f7447c60e31483b06dee85ab1fc49cb9035eb170ceb0d8b3b6ac5eb"
    sha256 monterey:       "61b66a2490d0c657995107d54372edd509ad6ba0ec76014894f279a7b29979ec"
    sha256 big_sur:        "f4d74a93301d7e892ba17788c52ce4ab1591f554085f521f9426a6e1f47d357c"
    sha256 x86_64_linux:   "19d0c4d79b46c67fe55393e48a10f02f3768a2778fcca2732203e78204636a65"
  end

  depends_on "pkg-config" => :build
  depends_on "enet"
  depends_on "gettext"
  depends_on "sdl2"
  uses_from_macos "curl"

  on_macos do
    depends_on "gcc"
  end

  on_linux do
    depends_on "openal-soft"
  end

  fails_with :clang

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = fork { exec bin/"7kaa", "-win", "-demo" }
    sleep 5
    system "kill", "-9", pid
  end
end
