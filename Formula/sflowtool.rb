class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "https://inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v5.04/sflowtool-5.04.tar.gz"
  sha256 "daf9d7afd03f902b4ee12775bb04fca718112105bac1b33c7534f5f65e691a82"

  bottle do
    cellar :any_skip_relocation
    sha256 "fac2b6e8b9e9e2ea073b5da8f749113f8ea0bf702e93dcb2669f68d305513321" => :mojave
    sha256 "d0b7f4a9a4f8622777e2916cb5da40c332a18848edbd651975b691f40793d899" => :high_sierra
    sha256 "21545a0ccb86edfe6e7dd0b5526fa8d39890e02739c1e99bf1d76341c6d91b3c" => :sierra
  end

  resource "scripts" do
    url "https://inmon.com/bin/sflowutils.tar.gz"
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
