class Sifu < Formula
  desc "Installation of Sifu tool."
  homepage "https://codesifu.com"
  url "https://codesifu.com/download/sifu-0.1.1.tar.gz"
  sha256 "d0ef00a475766bf4717b4721044bdbd0f1c8c02be3a1f824738d306b08a06cd2"

  depends_on :java # sifu runs on JVM

  def install
    rm_f Dir["*.bat"]
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/sifu"
  end
end
