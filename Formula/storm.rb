class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=storm/apache-storm-2.2.0/apache-storm-2.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/storm/apache-storm-2.2.0/apache-storm-2.2.0.tar.gz"
  sha256 "f621163f349a8e85130bc3d2fbb34e3b08f9c039ccac5474f3724e47a3a38675"
  license "Apache-2.0"

  bottle :unneeded

  conflicts_with "stormssh", because: "both install 'storm' binary"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/storm"
  end

  test do
    system bin/"storm", "version"
  end
end
