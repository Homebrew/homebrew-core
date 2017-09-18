class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.3.tar.gz"
  sha256 "10cdd7b67779de2ef41b9a263498e9e6831ef480a726e1bd97ec0287b1a4b49b"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "d5150fd5a935c207ee7c790903a1837aa5d20e22f66cd3fa79a31f5ae4c8768b" => :high_sierra
    sha256 "5a6447c459ca211b62e7ec67126bda75d37273df3d1a27580ed87ac4356a3115" => :sierra
    sha256 "4153061a94797bcf84f0b2804373ae6067e1e977bb206a88031b80ac920debf5" => :el_capitan
    sha256 "af90cb553fe0e51ac10eae06f5fac9ea922231948333c4372a419a08b66eace5" => :yosemite
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
