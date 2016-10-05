class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "http://www.inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v3.37/sflowtool-3.37.tar.gz"
  sha256 "5375a8173474d7e43f3811f66e6b31591c0dbf0ca88c2bc2eb7a52001f5bc329"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed8c5b869bc0084118412a682a595161ef0aa5ca205a1df7f5434d29392133c5" => :sierra
    sha256 "55eaecf78e96e174843e07035a1ef88e7e73d5069d21cb3a9a32431ff5e7ec1f" => :el_capitan
    sha256 "59e93210082db0f9bc76a68f16d68f077428b12054f3dab2e81bbf1b88bfca5d" => :yosemite
    sha256 "23009b43180daab12cbd7713e1a29941207157870dedd4d1e86c0071df94f24c" => :mavericks
  end

  resource "scripts" do
    url "http://www.inmon.com/bin/sflowutils.tar.gz"
    sha256 "45f6a0f96bdb6a1780694b9a4ef9bbd2fd719b9f7f3355c6af1427631b311d56"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    (prefix/"contrib").install resource("scripts")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sflowtool -h 2>&1")
  end
end
