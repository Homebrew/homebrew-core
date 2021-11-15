class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "3d766dc1856d04a8fb6de9942a6220d754d0fa7eae635d5287e7b1cf794c4f45"
  license "LGPL-2.1-or-later"
  head "https://github.com/MacPaw/XADMaster.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "5cedc1ed00cb1f638f6e7d7f026196c19aaf8e2ce9eacb7d9220b98cae2f0649"
    sha256 cellar: :any, arm64_big_sur:  "16091256fd3c0d13a774fc1900b7b21584fb9eee669a65de56906e188fbcc665"
    sha256 cellar: :any, monterey:       "2da5bda2a8ad54072fffd22e81c3b3b85320f8d68b993fdc4282dc6c87cec0e6"
    sha256 cellar: :any, big_sur:        "a92a0fd33d7598591efa5dc01692221053cdc612bb218f46df422af0bd5082c6"
    sha256 cellar: :any, catalina:       "6207848baad1fda03e3bdda9a8cd621ef2d226a02fcf4219fec64c9f418b9a0e"
    sha256 cellar: :any, mojave:         "f09e3c1eb465cec023037048305b493e3ed57696a775eb121076951b8ae63e76"
  end

  depends_on xcode: :build

  resource "universal-detector" do
    url "https://github.com/MacPaw/universal-detector/archive/refs/tags/1.1.tar.gz"
    sha256 "8e8532111d0163628eb828a60d67b53133afad3f710b1967e69d3b8eee28a811"
  end

  def install
    resource("universal-detector").stage buildpath/"../UniversalDetector"

    # Link to libc++.dylib instead of libstdc++.6.dylib
    inreplace "XADMaster.xcodeproj/project.pbxproj", "libstdc++.6.dylib", "libc++.1.dylib"

    # Replace usage of __DATE__ to keep builds reproducible
    inreplace %w[lsar.m unar.m], "@__DATE__", "@\"#{time.strftime("%b %d %Y")}\""

    mkdir "build" do
      # Build XADMaster.framework, unar and lsar
      arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
      %w[XADMaster unar lsar].each do |target|
        xcodebuild "-target", target, "-project", "../XADMaster.xcodeproj",
                   "SYMROOT=#{buildpath/"build"}", "-configuration", "Release",
                   "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}", "ARCHS=#{arch}", "ONLY_ACTIVE_ARCH=YES"
      end

      bin.install "./Release/unar", "./Release/lsar"
      %w[UniversalDetector XADMaster].each do |framework|
        lib.install "./Release/lib#{framework}.a"
        frameworks.install "./Release/#{framework}.framework"
        (include/"lib#{framework}").install_symlink Dir["#{frameworks}/#{framework}.framework/Headers/*"]
      end
    end

    cd "Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end

  test do
    cp prefix/"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}/lsar README.md.gz")
    system bin/"unar", "README.md.gz"
    assert_predicate testpath/"README.md", :exist?
  end
end
