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
    sha256 arm64_sequoia:  "032a3a0307bd45b73dd33ebaf29a83670fe45ddaa8db0e5043cb49d45c9ff625"
    sha256 arm64_sonoma:   "0538f01561c991e0ef25767624f8128516e2886fff6892c045163add87b82b03"
    sha256 arm64_ventura:  "7f964ac849ddfcb41f1deb913ac3f87e4d426a0caabb2f327ef2aa9f1820d29c"
    sha256 arm64_monterey: "368104c0637397af096cf0c77a02c16360e94e7007906a910f2d32588876a597"
    sha256 arm64_big_sur:  "b8cb6def3fcc6b7d7f501825caea49f9a79e11c8233a9b7f5c2c8330ed12e209"
    sha256 sonoma:         "d1c5fe322a26ee51c9a467b65b09da51f79f338bf9c9c765ceb2964884781ade"
    sha256 ventura:        "caccaab293176a553d5de69b2ad00b641292e8a716ab670c55cf4eecd2ea9946"
    sha256 monterey:       "de4af0d1f139d9315cdc9e026885bbae192c0d0a8bc7258760fad0010b273109"
    sha256 big_sur:        "38ef036f2d21f70bc7a89a7603ec581dc185e076a747200630a7f55f6b835b29"
    sha256 x86_64_linux:   "b3ba3202ca789169da6b0eb0173e686b97866e37ac12f0f10429e747c4ce0751"
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
