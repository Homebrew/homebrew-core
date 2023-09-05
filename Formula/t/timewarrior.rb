class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.5.0/timew-1.5.0.tar.gz"
  sha256 "51e7c2c772837bbd6d56da8d16506c4b6de8644166e0b5234ad36ae6a70dd4f6"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d00a549d6ad37ba6c96d9a3f0209a4de7287b13362dda2bba7ee2b702549454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ce0109b54f6387ade3734ea72b4cbe28135632f92b121d6ef1e75e2bf898f7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c58e3f9cd3e70122f1a6e7d739af9d5e4f4f94f0e374683cc5d65fa4ae3cde0e"
    sha256 cellar: :any_skip_relocation, ventura:        "e7e5039faa29be1454075cb48f0f614914ab6466ead34c204dac731c90e9d0ab"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e53323e1d6164518ae64d466b2f02b91614e7ad3aa5d44de92337563f23350"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef1845768857d8f77479d7cdf74a08b3df4f989d8ac5100fd9aaaa378b89d1a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be419258bfc09e85c53c9543c30aabf32d792a751a0034edc594d6b2fc277524"
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
