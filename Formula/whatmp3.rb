class Whatmp3 < Formula
  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.8.tar.gz"
  sha256 "0d8ba70a1c72835663a3fde9ba8df0ff7007268ec0a2efac76c896dea4fcf489"
  revision 2
  head "https://github.com/RecursiveForest/whatmp3.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "192361cf51ca2e2aeb3312de0325c81224f9fa655da04cb6c2ee47e21247e84d" => :catalina
    sha256 "6b36c6382c121ba067270c41d336af706df2f2a531e02703f629557aaa8206d7" => :mojave
    sha256 "976769c7868f672a9a5bd625b1c6d4e557dbbaf74f9d4274ebac0a1b0afe920a" => :high_sierra
    sha256 "976769c7868f672a9a5bd625b1c6d4e557dbbaf74f9d4274ebac0a1b0afe920a" => :sierra
    sha256 "976769c7868f672a9a5bd625b1c6d4e557dbbaf74f9d4274ebac0a1b0afe920a" => :el_capitan
  end

  depends_on "flac"
  depends_on "lame"
  depends_on "mktorrent"
  depends_on "python"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"flac").mkpath
    cp test_fixtures("test.flac"), "flac"
    system "#{bin}/whatmp3", "--notorrent", "--V0", "flac"
    assert_predicate testpath/"V0/test.mp3", :exist?
  end
end
