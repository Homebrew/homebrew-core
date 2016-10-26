class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "http://www.inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v3.39/sflowtool-3.39.tar.gz"
  sha256 "4b9125bdd5365e02144dfdaa29d9ea5227f007f610002e3ff5ea38eaa1f2b748"

  bottle do
    cellar :any_skip_relocation
    sha256 "9644466fe789330526f6fe2300f3de69050e0c3a7f2475a2357d496eb54ee627" => :sierra
    sha256 "c543ae1a2f3cdea6c6c7b4b79e9d2d6e1c33ea7f2eae9d7b5928b9cf6bbdcbcc" => :el_capitan
    sha256 "55f3a9bf8b015dc8f024d50555bbbc91c4cd7251d85e1a5ba9c3b2b856b76ff2" => :yosemite
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
