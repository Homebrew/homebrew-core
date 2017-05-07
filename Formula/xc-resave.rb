
class XcResave < Formula
  desc "Force Xcode to re-save a project from command line"
  homepage "https://github.com/cezheng/xc-resave"
  url "https://github.com/alexgarbarev/xc-resave/archive/0.0.1.tar.gz"
  sha256 "cc872a719c324ce4d4c05fc2c489dfdf18ced2a8f4ac07c9000eefc48224620b"

  def install
    system "make"
    bin.install "xc-resave"
  end

end
