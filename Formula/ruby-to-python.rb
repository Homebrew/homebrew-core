class RubyToPython < Formula
  desc "Converts ruby to python"
  homepage "https://github.com/snood1205/ruby-to-python"
  url "https://github.com/snood1205/ruby-to-python/archive/0.0.1.tar.gz"
  sha256 "0ffbb23df844a0d18f74fb41f9f6117419557a94913307a059886e68c1f06885"

  def install
    bin.install "r2p"
  end

  test do
    system "r2p", "ruby-to-python.rb"
  end
end
