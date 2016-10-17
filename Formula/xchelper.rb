class Xchelper < Formula
  desc "Build your Swift code on Linux with Xcode. Archive and upload to S3."
  homepage "https://github.com/saltzmanjoelh/XcodeHelper"
  url "https://github.com/saltzmanjoelh/XcodeHelper/archive/master.tar.gz"
  version "1.0.10"
  sha256 "5b69efd533d89e3a6d202e9021df27a958533d691e64cfb2192713d7acbc1597"

  def install
    system "swift", "build", "--configuration", "release"
    bin.install "./.build/release/xchelper"
  end

  def uninstall
    system "swift", "build", "--configuration", "release"
    bin.install "./.build/release/xchelper"
  end

  test do
    system "swift", "test"
  end
end
