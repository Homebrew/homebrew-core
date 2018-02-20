class Rkhunter < Formula
  desc "Rootkit hunter"
  homepage "https://rkhunter.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.6/rkhunter-1.4.6.tar.gz"
  sha256 "9c0f310583ff0dd8168010acd45c7d2e3a37e176300ac642269bce3d759ebda0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4784b2369cbe305902a239a16695c5ecafca733ad1497a9d043cdea62f5f1771" => :high_sierra
    sha256 "d0f86dcf70bb5a827317f2c487d4238b61b03edc87cd7a0d1d0dcba1ea87d774" => :sierra
    sha256 "dddb86855d2ab0bb0a82c5861eea40b5efddaa8feff85744bebcd213aeea2bdd" => :el_capitan
    sha256 "5019567a795b47aa07bb27c897dd1971795d220747c38968e6834ff5edf430cc" => :yosemite
  end

  def install
    system "./installer.sh", "--layout", "custom", prefix, "--install"
  end

  test do
    system "#{bin}/rkhunter", "--version"
  end
end
