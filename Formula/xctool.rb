class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.tar.gz"
  sha256 "d1eb62840ed0b7488f9d432c3d3bd198f357ee7bd268fea7e9d17166dfd90f25"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "afefdffcddd0e2eac16c39076877b6357e0926cf7aa9a88ef3e6e3926265c791" => :sierra
    sha256 "1fba6ae78da7166c8d0729ac72935b3be08bdfea0dfe98bbec61face97310152" => :el_capitan
    sha256 "e8a9bf04d28df9cd6b859e1e37b446ce5eec5955f86fb614a577182d78147b68" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    system "./scripts/build.sh", "XT_INSTALL_ROOT=#{libexec}", "-IDECustomDerivedDataLocation=#{buildpath}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
