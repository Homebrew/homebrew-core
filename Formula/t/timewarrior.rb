class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.6.0/timew-1.6.0.tar.gz"
  sha256 "cd1aa610ed50558bb2cf141022fa7b41523091ac3ae5fbb9c2d459cfe1afc782"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5b85bc69baaf5f3a7b4fc9f8cad837345e2ef1d9b7f3640dcba31f3d2c2860a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "462dcb8852fd07de6b1f64c1dec89ddb1366a6ebc214b139ac57cdee635fd639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d11690a98ad4656e567e50e88c4be052e5b36529f5282268274e0867c4083740"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fc1d95ffc3454a256bba300c2cc4955d35c152c28f1610b4ed816d6b8202487"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f332be089219d432c46040c0f4187a6503106249d4cb3a4f71461a543baa482"
    sha256 cellar: :any_skip_relocation, ventura:        "d58a0e165553b6421407ad728753fdafb9ae198ec19ac6b6ed0baec1ef46fead"
    sha256 cellar: :any_skip_relocation, monterey:       "7423d9c71a154b11339386853f20aa44bc75559c3228d32488e2a5c2b3d4eecd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe15c7faa924d709dacfc5cae8be9967977fa86b55de5e8e43b058ce4f811428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c904461326ba89be04e58b6bed0c329109559093395c863172b72811ef89210e"
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
