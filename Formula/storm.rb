class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=storm/apache-storm-1.0.2/apache-storm-1.0.2.tar.gz"
  sha256 "b3fd2475e88e4b5e30f0e47eab70363419d67c15ddc7fe1f3c423ac0499eb76e"

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
