class Skymaker < Formula
  desc "Generates fake astronomical images"
  homepage "https://www.astromatic.net/software/skymaker"
  url "https://www.astromatic.net/download/skymaker/skymaker-3.10.5.tar.gz"
  sha256 "a16f9c2bd653763b5e1629e538d49f63882c46291b479b4a4997de84d8e9fb0f"

  bottle do
    cellar :any
    sha256 "af78e7af9c84517e8f7db071ef3718a34eafc39d6eac3357d77ee183d4fe2cdf" => :catalina
    sha256 "ef2182885eb6952289057ce2756ac56ec9a88397e746b694529a937eaa28b943" => :mojave
    sha256 "6e7aa4c817624d5631293d0421b25eec132e41bfe3d75f9044a85dd02f73de4a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "fftw"

  def install
    system "autoconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "added", shell_output("#{bin}/sky 2>&1")
  end
end
