class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.8.0/timew-1.8.0.tar.gz"
  sha256 "1ea54302dcefa4aa658f89b6b825f0e8b49c04f15cf153a2e7d8bce5525920b4"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7edd9e0034a3bd39c258258841e95b440bc66ec2598daf7777350f84df0e196c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40022ab9a10321ff7cfdb94aa6c7addc287b49502405ea252a2be3f5425ab7d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9e5fcb7c4d143cc6f76ab26bddf904983f62d15f14691189a1c71d0d4749a52"
    sha256 cellar: :any_skip_relocation, sonoma:        "f54d9143c188b384873fde1f7b6ecb520ffff93db922f9dbe334bb9b764b1ef9"
    sha256 cellar: :any_skip_relocation, ventura:       "1d62dadfee84d1d5df682c0ab60856a5a17cc4b2fe28c061eb4e41dfdce31b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b8a1aa42b0f42f513e76fe1708b327ea8fc23f7c99b181fa53f336f308c5f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7285a172a3f71d7c8798d673026f50948933ada3aa28205764ba520523c532"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"

    man = OS.mac? ? "man" : "gman"
    system man, "-P", "cat", "timew-summary"

    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end
