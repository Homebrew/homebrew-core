class Xdk < Formula
  desc "Ecstasy Development Kit (XDK)"
  homepage "https://github.com/xtclang/xvm/"
  url "https://github.com/xtclang/xvm/releases/download/v0.4.2/xdk-0.4.2.tar.gz"
  version "0.4.2"
  sha256 "b0b5217abf05de986e6211a7c8665b304fa89df1726749e4f1dd7eff1cbbe1fe"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    libexec.mkpath
    cp_r Dir[buildpath/"*"], libexec
    osname = OS.linux? ? "linux" : "macos"
    bin.install_symlink "#{libexec}/bin/#{osname}_launcher" => "xec"
    bin.install_symlink "#{libexec}/bin/#{osname}_launcher" => "xtc"
    bin.install_symlink "#{libexec}/bin/#{osname}_launcher" => "xam"
  end

  test do
    assert shell_output("xec", 255).include? "Error: Module file required"
  end
end
