class Snowdrift < Formula
  desc "App to perform testing and validation of firewall rules"
  homepage "https://comcast.github.io/"
  url "https://github.com/Comcast/snowdrift/archive/snowdrift-1.0.tar.gz"
  sha256 "f48b6beec8f6f93d1e57709f6ff8853352ccea7e21e28b53f9a31dacd3e27e96"

  def install
    bin.install "snowdrift"
  end

  test do
    system "false"
  end
end
