class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.04.01.tar.gz"
  sha256 "5ecb0c1358c24fd88ee6a22d05233c6e035826e85ee7b87f8e0226b558fae480"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "6a49e61922f6aaf68da0f4b8a4b0a029325a5b0c597b768de0978781d43af9ed"
    sha256 arm64_sonoma:  "97b551840a707e56354390b119e6209c7e813bc67ab961a716377e98063f4966"
    sha256 arm64_ventura: "7934176585818060b8746835adf8b6bf83a3c495b22ca86769ae803ddb909fa6"
    sha256 sonoma:        "88782c8b1f9d73d2b66433854efd22d213fc5669519a46955b5e3b8028f621e0"
    sha256 ventura:       "203ed1904d81843ca7749e991c06b46bdc8555d1d281ab063efc8be8a8769c6c"
    sha256 arm64_linux:   "0867df1ec14287f61071b43cc32ec23db6ef69885e6a4ca41b22e2634ccc6994"
    sha256 x86_64_linux:  "891f549faeaf31bb0c824e5a5d7795a834db2e8fe545a5143f8c82d7969732bf"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Fix to error: unsupported option '-ffat-lto-objects' for target 'arm64-apple-darwin24.4.0'
    inreplace "configure", "-ffat-lto-objects", "" if DevelopmentTools.clang_build_version >= 1700

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end
