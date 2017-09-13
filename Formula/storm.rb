class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=storm/apache-storm-1.1.0/apache-storm-1.1.0.tar.gz"
  sha256 "6f584b45ec7f8d0cfd2fa78deb5de392bece07a09158a948b0ed3016ef689142"

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
