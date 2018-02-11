class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=storm/apache-storm-1.1.1/apache-storm-1.1.1.tar.gz"
  sha256 "284b43c2e667ccb600605769e76dfc981140d769a684253f37309f85fea2a951"

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
