
class Saverun < Formula
  desc "Save and run any program"
  homepage "https://github.com/MenkeTechnologies/SaveRun"
  url "https://github.com/MenkeTechnologies/SaveRun/archive/v1.0.1.tar.gz"
  sha256 "2602a03a2e7a2a28c83ae52395ca83dfed805ede1000c374c48549132d9da949"

  depends_on "fswatch" => :run
  depends_on "bash" => :run

  bottle :unneeded

  def install
     bin.install "bin/save-run-compiled"
     bin.install "bin/save-run-interpreted"
  end

  test do
  
  end
end
