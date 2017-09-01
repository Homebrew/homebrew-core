class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.3.tar.gz"
  sha256 "eeb5ffda73e67273df3eddd7a00ab8fbd5ef1eace96405c5647b2a414d152783"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "cefe53bdb832edb823e5fa4dc8a2536a9ca24b3d64ed0aa11018ac34b6d81d8c" => :sierra
    sha256 "968caec53bd32bcccc20fa01df5c9514bbc5bf6584ede354456ad4576609b3fc" => :el_capitan
    sha256 "47f1e824082e5f1519573b40fa4772fea9daec559b1366d2171b412a1e216492" => :yosemite
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
