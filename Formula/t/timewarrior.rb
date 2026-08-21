class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.10.0/timew-1.10.0.tar.gz"
  sha256 "a9c9966cfd9fed6c4d4895dc2de530902e736608f4033799af4fe06edf0dd438"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ad712be1d19f06d4676c19784de958e4405048105cbe7bd87759e40c7858bf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5a5d58e9349840b8ca58c9e4dbaba061e92792e08be0d665c214ccad0d8d61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b8b5e8b52d11871bad01c9262e4ac36cec1d6fbad7ef5c5ecd80d7939b5b843"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8f1a12e54b61db1a456c119ade477b1665207c6b37b72fa9c484f9ca4ce70b5"
    sha256 cellar: :any,                 arm64_linux:   "8565ce7b54bfd5c7da64e18fecace39e46b32b1d1b66df463eb28b891eee9898"
    sha256 cellar: :any,                 x86_64_linux:  "99c95ebc00a8761580a4804a6e05ec096ca4e4525f7c8239ca6043f31773c5c2"
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
