class Sysinfo < Formula
  desc "Simple CLI to show system information"
  homepage "https://github.com/amitbhujbal/sysinfo"
  url "https://github.com/amitbhujbal/sysinfo/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"   # calculate with: shasum -a 256 v1.0.0.tar.gz
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "sysinfo.py" => "sysinfo"
  end

  test do
    assert_match /System Info/, shell_output("#{bin}/sysinfo")
  end
end
