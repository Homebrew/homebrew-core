class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.1.tar.gz"
  sha256 "9db246a95af6716cca93a57b45905c97b3228c1167b4ae7c9461715cfb3e9df0"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "789cf899f997fc3ea3bff4272fd3c95ed73fd1740ed5a6584216a99bdf1c7f86" => :sierra
    sha256 "6ca96efae7511489946fd22319b7e327663facd770659c17ac35d122992d33b1" => :el_capitan
    sha256 "f33d561b96370de7e7b190ec1fe2ff7f56068b23faac81438dbddcbd6c5215c6" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    system "./scripts/build.sh", "XT_INSTALL_ROOT=#{libexec}", "-IDECustomDerivedDataLocation=#{buildpath}"
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
