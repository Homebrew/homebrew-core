class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.7.0/timew-1.7.0.tar.gz"
  sha256 "fd7433bf6964b3aab22c0f9542a14b4182dbcba092bd214e03d57d326d2bc8b2"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9ab250655e4c679b0780b688a9a2f57f7d3db49e98214d692bf602286243606"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9efe2d9e4e9d43bf0b8a4f4a924c82a9171b42c4aee492b6ff81971b9dfd103f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65bfbf022991715bd08ed710cba2a6b0a9db67f69125046326147c2f9160f5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "24042ac1caa7f447f2d3580f4cfcfa30336b1358f1291891246b4d7f72b18e35"
    sha256 cellar: :any_skip_relocation, ventura:        "226d6bac5f812634849d11eddd3385f47681239d6e0c7ee4b8441f46d7abf8a7"
    sha256 cellar: :any_skip_relocation, monterey:       "b0a0d0cd9424f7f709a84828a3bcc9ab88f27dcffb9cdc25f85d8fc756de023d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a762e451f33ac6ce91480778238d1489a92fce5972bdb8e1db5d0801ae7fefb1"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build

  on_linux do
    depends_on "man-db" => :test
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
