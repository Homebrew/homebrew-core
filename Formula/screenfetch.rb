class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.8.0.tar.gz"
  sha256 "248283ee3c24b0dbffb79ed685bdd518554073090c1c167d07ad2a729db26633"
  head "https://github.com/KittyKatt/screenFetch.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "3e69c6119f9b9b4133817ce2d06de71317866c0b4aa08773aec038abef2d31ef" => :mojave
    sha256 "8e0571c592a9ae4b20d7e88e12dcbde9b722856721c3227d3334800cfd8445f5" => :high_sierra
    sha256 "62441999c591325de600f4cbd5d46e4157c443cfb514a3b1dfce8764c911785d" => :sierra
    sha256 "62441999c591325de600f4cbd5d46e4157c443cfb514a3b1dfce8764c911785d" => :el_capitan
    sha256 "62441999c591325de600f4cbd5d46e4157c443cfb514a3b1dfce8764c911785d" => :yosemite
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
