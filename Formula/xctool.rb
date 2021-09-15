class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebookarchive/xctool"
  url "https://github.com/facebookarchive/xctool/archive/0.3.7.tar.gz"
  sha256 "608522865dc42959a6240010c8295ce01278f4b7a8276d838f21a8973938206d"
  license "Apache-2.0"
  head "https://github.com/facebookarchive/xctool.git", branch: "master"

  bottle do
    sha256 cellar: :any, catalina:    "0cf8c734d095ab97b2d5537b67d3f13e6ff8f38c46503ea02b9eba98ff35942c"
    sha256 cellar: :any, mojave:      "8b116346555e2616619e577d3ce3c69a24d66cb505ee048ba316ab2880736043"
    sha256 cellar: :any, high_sierra: "055172ba606bf94416513e418007f849a08ff24a3b3484fb67c1b4f854123bb9"
  end

  deprecate! date: "2021-05-24", because: :repo_archived

  depends_on :macos
  depends_on xcode: "7.0"

  def install
    xcodebuild "-workspace", "xctool.xcworkspace",
               "-scheme", "xctool",
               "-configuration", "Release",
               "SYMROOT=build",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "XT_INSTALL_ROOT=#{libexec}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  def post_install
    # all libraries need to be signed to avoid codesign errors when
    # injecting them into xcodebuild or Simulator.app.
    Dir.glob("#{libexec}/lib/*.dylib") do |lib_file|
      system "/usr/bin/codesign", "-f", "-s", "-", lib_file
    end
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
