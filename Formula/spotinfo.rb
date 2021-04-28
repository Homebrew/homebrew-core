class Spotinfo < Formula
  desc "Explore AWS EC2 Spot: types, savings, price, and interruption frequency"
  homepage "https://github.com/alexei-led/spotinfo"
  url "https://github.com/alexei-led/spotinfo/archive/refs/tags/0.4.1.tar.gz"
  sha256 "3c3675f24e81967a4dfbe59035cb2047e5b379ff7187220d20d623575bce4844"
  license "Apache-2.0"
  head "https://github.com/alexei-led/spotinfo.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "wget" => :build

  def install
    system "make", "build"
    bin.install ".bin/spotinfo"
  end

  test do
    output = shell_output("#{bin}/spotinfo --type=t4g.small --output=text")
    assert_match "type=t4g.small, vCPU=2, memory=2GiB", output
  end
end
