class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "http://www.inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v3.38/sflowtool-3.38.tar.gz"
  sha256 "a9a90bb3db6894bc6047f1636d608237b82a5b0a2e4554a7a386407d2be4cdd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6b31e4e699eef4491e83e454912994f7b70d2f0a515c4f61b7ad4d1dba77d4e" => :sierra
    sha256 "d9377c0cd33fc8ce38fc0786ee3a65f991acd68179a87b499af78e420d84e7f0" => :el_capitan
    sha256 "127b3d76c88bb5aa71b2a9d54d0b8c18c550699e0c6c6f1cd3d2b455e3318086" => :yosemite
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
