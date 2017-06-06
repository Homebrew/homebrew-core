
class Saverun < Formula
  desc "Run your program on save automatically"
  homepage "https://github.com/MenkeTechnologies/SaveRun"
  url "https://github.com/MenkeTechnologies/SaveRun/archive/v1.0.3.tar.gz"
  sha256 "ce205b60018cbbc216a90bcaa66cea3db969d3a766449dbb23fd63ed9721dc2c"

  depends_on "fswatch" => :run
  depends_on "bash" => :run

  def install
    bin.install "bin/save-interpret-run"
    bin.install "bin/save-compile-run"
  end

  test do
    system "save-interpret-run -h"
  end
end
