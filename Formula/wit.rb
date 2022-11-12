class Wit < Formula
  desc "Tool to manipulate Wii and GameCube ISO images and WBFS containers and disks"
  homepage "https://wit.wiimm.de/"
  url "https://github.com/Wiimm/wiimms-iso-tools/archive/fc1c0b840cb3ac41ca6e4f1d5e16da12b47eab58.tar.gz"
  version "3.05a"
  sha256 "ebcff01c6d674f21a8c63ef0530d0516616d082e1d5041863ebc744549f937ea"
  license "GPL-2.0-or-later"

  def install
    system "make", "--directory=./project", "SYSTEM=mac"
    bin.install "./project/bin/wdf" => "wdf"
    bin.install "./project/bin/wfuse" => "wfuse"
    bin.install "./project/bin/wit" => "wit"
    bin.install "./project/bin/wwt" => "wwt"
  end

  test do
    system "#{bin}/wwt"
    system "#{bin}/wit"
  end
end
