class Spry < Formula
  desc "Declarative web application framework"
  homepage "https://github.com/programmablemd/packages"
  license "MIT"

  if OS.mac?
    url "https://github.com/programmablemd/packages/releases/download/v1.7.4/spry-macos.tar.gz"
    sha256 "08b5519d337ca1e8c13ad9ae9a176560bd8281e63c735326896398662f8ef3a7"
    version "1.7.4"
  elsif OS.linux?
    url "https://github.com/programmablemd/packages/releases/download/v1.7.4/spry_1.7.4-ubuntu22.04u1_amd64.deb"
    sha256 "0b98bbdbdc9f77bee3ce03f56d5f695a636c8265db150d3bfb62512804161fe1"
    version "1.7.4"
  end

  def install
    if OS.mac?
      bin.install "spry-macos" => "spry"
    elsif OS.linux?
      # For Linux, extract the DEB package using dpkg-deb
      system "dpkg-deb", "-x", "spry_1.7.4-ubuntu22.04u1_amd64.deb", "."
      bin.install "usr/bin/spry"
      man1.install Dir["usr/share/man/man1/*.1.gz"]
    end
  end

  test do
    system "#{bin}/spry", "--version"
  end
end
