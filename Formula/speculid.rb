class Speculid < Formula
  desc "Easily Build Xcode Image and App Icon Assets from Graphic Files."
  homepage "http://www.speculid.com"
  url "https://github.com/brightdigit/speculid/archive/1.0.0.tar.gz"
  sha256 "929f313fd09576d4d17ea48afe8a0247fb2e788b000b5ae3bdaade71f2b2df3f"
  head "https://github.com/brightdigit/speculid.git", :branch => "develop"

  option "with-debug", "Compile Speculid with debug options enabled"

  depends_on "homebrew/gui/inkscape"
  depends_on "imagemagick"
  depends_on :xcode => ["8.0", :build]
  depends_on :macos => :yosemite

  def install
    configuration = "Release"

    if build.with? "debug"
      configuration = "Debug"
    end

    xcodebuild "-workspace", "speculid.xcworkspace", "-scheme", "Speculid Application", "-derivedDataPath", buildpath, "build", "-configuration", configuration, "SYMROOT=#{buildpath}/Build/Products", "CODE_SIGNING_REQUIRED=NO"
    system "zip", "-r", "examples.zip", "examples"
    prefix.install "examples.zip"
    prefix.install "shasum.sh"
    prefix.install "#{buildpath}/Build/Products/#{configuration}/Speculid.app"
    bin.install_symlink prefix/"Speculid.app/Contents/MacOS/Speculid" => "speculid"
  end

  test do
    system "unzip", "#{prefix}/examples.zip", "-d", testpath
    assert_equal shell_output("cat #{testpath}/examples/shasum"), shell_output("#{prefix}/shasum.sh #{bin}/speculid #{testpath}/examples/Assets")
    system "#{bin}/speculid", "--version"
  end
end
