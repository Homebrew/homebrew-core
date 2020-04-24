class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.08.tar.xz"
  sha256 "07090ed5aef4e8d406f9c1927fc816db1068ab02d3aa53120481b14872a9c5f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "440903715c4c273ccb41d47093484ba19ef9ec1f0bb4289c7aa1920afc3ee096" => :catalina
    sha256 "7e5c6db7552059a70ea0a0f8b2f17550231d07ebd8440aa12c101b47a453791c" => :mojave
    sha256 "e42d7967ab155c5b3e7b2067730705ccd2fadff100d53bfd3da466f1b4cd0c99" => :high_sierra
  end

  depends_on :macos => :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
