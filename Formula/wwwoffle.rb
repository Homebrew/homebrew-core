class Wwwoffle < Formula
  desc "Better browsing for computers with intermittent connections"
  homepage "https://www.gedanken.org.uk/software/wwwoffle/"
  url "https://www.gedanken.org.uk/software/wwwoffle/download/wwwoffle-2.9j.tgz"
  sha256 "b16dd2549dd47834805343025638c06a0d67f8ea7022101c0ce2b6847ba011c6"
  license "GPL-2.0"

  livecheck do
    url "https://www.gedanken.org.uk/software/wwwoffle/download/"
    regex(/href=.*?wwwoffle[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "46fe1104b067d2e6c93edf3f4d3ca12e82e2e6b3db5ba99b3b94d3d4ce23fc6a" => :big_sur
    sha256 "539834a9911070c87d6c34d0b12a16ab29d58fa4688f74ca1103c90c58364db1" => :arm64_big_sur
    sha256 "5e01196bd5b95300b944ac6c5bd7cf10999a3ec9cb24f2f2a09b97b0256b87f9" => :catalina
    sha256 "503407c9e3e1cdfe8382b25e8709d5f92675ac04f7d9b42bb4ab08b02a6f5818" => :mojave
    sha256 "090085b4a39e90929744310494ef3157dfc77f7c2910047dfbdc75c75fe7c8f7" => :high_sierra
    sha256 "9310fffe992916bf09700c8d6fd018943a14c73c27f28e3c61548f56b7f301d2" => :sierra
    sha256 "0877d44d105e2ec35e38e2d2e760f6c2973f53f98d784ccf16bed6d47e37db38" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wwwoffle", "--version"
  end
end
