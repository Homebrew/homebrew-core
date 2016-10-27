class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.tar.gz"
  sha256 "d1eb62840ed0b7488f9d432c3d3bd198f357ee7bd268fea7e9d17166dfd90f25"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "331b26058f58adf1ed4b337ad897f22a06ed148d4ddf0b7429258ca72ba59dfa" => :el_capitan
    sha256 "39ced7bed2490b8f4c2ce21879a66f7055ab18b713e763b9c28feff4506b689c" => :yosemite
    sha256 "d035eebe4a7203b1ed2db3d59c3f4a6f418cad5e3cfd872355d0fa561c568b02" => :mavericks
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
