class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "https://inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v5.04/sflowtool-5.04.tar.gz"
  sha256 "daf9d7afd03f902b4ee12775bb04fca718112105bac1b33c7534f5f65e691a82"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ed1d462dbb2993bb369636d98ae7b38808c73592480fd428f259ef582e0b613" => :mojave
    sha256 "b797a335bf9b9910fd4da5a8d54c5dca233527cbc9cf6f72e9c1205a0bef5a57" => :high_sierra
    sha256 "359f80ea054dbb35c8878ac61aa0f18478e03e8e8c9a2a08d8f4fe8b86257469" => :sierra
    sha256 "683d0468235a5d78035c4fc4b4db19d503d4042adec9c38fa1b7e9c1233354e8" => :el_capitan
    sha256 "8957c4da2c6a3f9f17bd8a58b5472db7dcb4f4402467b3fba4f8beda76e4eff9" => :yosemite
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
