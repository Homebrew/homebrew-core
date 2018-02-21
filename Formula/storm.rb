class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=storm/apache-storm-1.2.1/apache-storm-1.2.1.tar.gz"
  sha256 "7b4a7b7d384f328c193c0942f0348ef5711e793d06a247d5bef9a9b8d7c3ed9c"

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
