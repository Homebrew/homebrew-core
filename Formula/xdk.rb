class Xdk < Formula
  desc "Ecstasy Development Kit (XDK)"
  homepage "https://github.com/xtclang/xvm/"
  url "https://github.com/xtclang/xvm/releases/download/v0.4.2/xdk-0.4.2.tar.gz"
  sha256 "b0b5217abf05de986e6211a7c8665b304fa89df1726749e4f1dd7eff1cbbe1fe"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    libexec.install buildpath.children
    osname = OS.mac? ? "macos" : OS.kernel_name.downcase
    bin.install_symlink "#{libexec}/bin/#{osname}_launcher" => "xec"
    bin.install_symlink "#{libexec}/bin/#{osname}_launcher" => "xtc"
    bin.install_symlink "#{libexec}/bin/#{osname}_launcher" => "xam"
  end

  test do
    assert_match "Error: Module file required", shell_output(bin/"xec", 255)
  end
end

