class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.9.0/sec-2.9.0.tar.gz"
  sha256 "741154d25db69706e2200e119b5cd32d65ae0b803d9c0faefcccfbcfe1c97503"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7ae34d4172afb4ead92b0ea30f0eef8b11262504cc74b35d92cc2de64841d4e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ca90f406c4776e7f7b4b20db45f8d960458b8e5e66789846e58359b4ca2c0fb"
    sha256 cellar: :any_skip_relocation, catalina:      "0ca90f406c4776e7f7b4b20db45f8d960458b8e5e66789846e58359b4ca2c0fb"
    sha256 cellar: :any_skip_relocation, mojave:        "0ca90f406c4776e7f7b4b20db45f8d960458b8e5e66789846e58359b4ca2c0fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ae34d4172afb4ead92b0ea30f0eef8b11262504cc74b35d92cc2de64841d4e6"
  end

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
