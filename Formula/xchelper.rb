class Xchelper < Formula
  desc "xchelper helps you stay in Xcode and off the command line. Build your Swift code on Linux with Xcode
Archive your project and upload to S3 for automatic deployment with Xcode Server
Keep the Xcode references to Swift dependency sources updated so that you don't have to keep change them when your dependencies update."
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
