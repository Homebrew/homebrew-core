class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=storm/apache-storm-1.0.1/apache-storm-1.0.1.tar.gz"
  sha256 "1574c08d8cfb6bc7509c78871e98a535f1386d6ca50fa71c880c39e8800620bf"

  bottle :unneeded

  conflicts_with "stormssh", :because => "both install 'storm' binary"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/storm"
  end

  test do
    system bin/"storm", "version"
  end
end
