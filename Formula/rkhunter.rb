class Rkhunter < Formula
  desc "Rootkit hunter"
  homepage "https://rkhunter.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.4/rkhunter-1.4.4.tar.gz"
  sha256 "a8807c83f9f325312df05aa215fa75ad697c7a16163175363c2066baa26dda77"

  bottle do
    cellar :any_skip_relocation
    sha256 "d314b78c20ac638e0e8db2488cde0d249fffcaf4fff983202019f7918fbd69e3" => :sierra
    sha256 "7c13ec707da81dfb0cdc9ad8b8ffd9d3549454db698379c6159f3d69c4ed617d" => :el_capitan
    sha256 "5269398b0bc05b26f47033f790c96c508ba8a072d904d6e06a4abbe4c3778e95" => :yosemite
    sha256 "1eeeab51dfa8dafeb1b4f9b283f89bf18180c4c55ef65b9b716f892ef53ee85f" => :mavericks
  end

  def install
    system "./installer.sh", "--layout", "custom", prefix, "--install"
  end

  test do
    system "#{bin}/rkhunter", "--version"
  end
end
