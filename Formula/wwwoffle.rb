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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1c21a7a1850d20ea78fbf76ee08b7b2341b3f37c23ea0f1a298416b18b613c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "539834a9911070c87d6c34d0b12a16ab29d58fa4688f74ca1103c90c58364db1"
    sha256 cellar: :any_skip_relocation, monterey:       "c9d09ae17f69d7f18e421b2ab893a1dccd64d15ad9a41f0d987c1c9c81bfaf86"
    sha256 cellar: :any_skip_relocation, big_sur:        "46fe1104b067d2e6c93edf3f4d3ca12e82e2e6b3db5ba99b3b94d3d4ce23fc6a"
    sha256 cellar: :any_skip_relocation, catalina:       "5e01196bd5b95300b944ac6c5bd7cf10999a3ec9cb24f2f2a09b97b0256b87f9"
    sha256 cellar: :any_skip_relocation, mojave:         "503407c9e3e1cdfe8382b25e8709d5f92675ac04f7d9b42bb4ab08b02a6f5818"
    sha256 cellar: :any_skip_relocation, high_sierra:    "090085b4a39e90929744310494ef3157dfc77f7c2910047dfbdc75c75fe7c8f7"
    sha256 cellar: :any_skip_relocation, sierra:         "9310fffe992916bf09700c8d6fd018943a14c73c27f28e3c61548f56b7f301d2"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0877d44d105e2ec35e38e2d2e760f6c2973f53f98d784ccf16bed6d47e37db38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd784479bb56270b0d643cb2cccbc9e48264423c4190c1a1b251988dd503b68"
  end

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wwwoffle", "--version"
  end
end
