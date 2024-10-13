class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.7.1/timew-1.7.1.tar.gz"
  sha256 "5e0817fbf092beff12598537c894ec1f34b0a21019f5a3001fe4e6d15c11bd94"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b56a2d57b45d9c90248412d0cfefb5e835c2b9579defa625c02d3aa5a197668c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "011894ee1488cab1f925146d51a4856d08c6d63437e6e91bae24484bbdda527b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fb57a435ceeaf1fa0b261f48dc438d40bb8d45b4895151e44a2d7951d587faa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eefaa54fa7a4e286990e3751316917daa84f8ff050dc1620eb57fd528870313"
    sha256 cellar: :any_skip_relocation, sonoma:         "65e2024a1bdd9e939272ae7ce8801811a1b29cff9c9e9f8d27755fe14f01641d"
    sha256 cellar: :any_skip_relocation, ventura:        "d96a671bf4dcdec6fd9da826ec95e013e520bc326a9130fff9f36979f7bff58a"
    sha256 cellar: :any_skip_relocation, monterey:       "a6cca6e51a04ed7106919357514290007475c794f23e756da10d9bbb5a3d1bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9073e350620c7067b35e6eea867ed7d02b45210cf8163673e7ee009ffcb1d1e4"
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
