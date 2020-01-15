class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "https://inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v5.05/sflowtool-5.05.tar.gz"
  sha256 "048c52ead856a23e927fb826ac7663aeaac98795e678792fd6f74c588f90825d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3e55e3b91333c14463670cfc709aa6333a2e6170c668b130e54a4f6b34d1557" => :catalina
    sha256 "59dac285649c6046b8e24a1308e9c56037cbb98e1223b5b37890b935b51edc91" => :mojave
    sha256 "1df8d53ae9d3978eec0655b09c1988c77db62b1c619731e2997ae9d770246158" => :high_sierra
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
