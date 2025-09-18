class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "40f5472df5f6356a4d6f48862a19091bd4de3f802b3444891b3bc4b710fb35ca"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff19077c89bbaed4baab592cc2fd196a8c0d3ab781afa4a45a8365ca9a6af40a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0296212716734c1aa848c53307e2c7650c884be26a7b725fac7177df7d6c844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "826894f992a241194151200adbbe897b0ec8ab6b9edea895196c1f3f73a0860d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8a82c47af7166beacbec8c91d49ec5f9f4b2a4575782be062f89e39ebb58c19"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ed9023f906bb2ce8b1c52f95ee427b8309b3582ab53972179abcc2311efb193"
    sha256 cellar: :any_skip_relocation, ventura:       "958524a5a0349f5ef1f9fd704b057a64228c5f240df7635a25bf7d8b41c984a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe39b7828600d9a73fbb7b9c587cf9676c8ca3479d88efd883b148fc9d11ea5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b6185fe4d08cba98dcabd29a327037a96c9872cadc0048bc60eb40ede9ba3b"
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    yankcmd = OS.mac? ? "pbcopy" : "xsel"
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=#{yankcmd}"
  end

  test do
    require "pty"
    PTY.spawn("echo key=value | #{bin}/yank -d = >#{testpath}/result") do |r, w, _pid|
      r.winsize = [80, 43]
      w.write "\016"
      sleep 1
      w.write "\r"
      sleep 1
    end
    assert_equal "value", (testpath/"result").read
  end
end
