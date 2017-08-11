class Up < Formula
  desc "Deploy infinitely scalable serverless apps, apis, and sites in seconds."
  homepage "https://github.com/apex/up"
  url "https://github.com/apex/up/releases/download/v0.1.6/up_0.1.6_darwin_amd64.tar.gz"
  version "0.1.6"
  sha256 "4d421689c7493891c355bd08078020195d35625292e2a18b89cee4d988408669"

  def install
    bin.install "up"
  end

  test do
    system "#{bin}/up", "version"
  end
end
