class Slimerjs < Formula
  desc "Scriptable browser for Web developers"
  homepage "https://slimerjs.org/"
  url "https://github.com/laurentj/slimerjs/archive/0.10.2.tar.gz"
  sha256 "282b7522e5fcdf37258a7753441e4b62dcdde22f3a2ab8554f29fc9750c41a8d"
  head "https://github.com/laurentj/slimerjs.git"

  bottle :unneeded

  def install
    cd "src" do
      system "zip", "-r", "omni.ja", "chrome/", "components/", "modules/",
                    "defaults/", "chrome.manifest", "-x@package_exclude.lst"
      libexec.install %w[application.ini omni.ja slimerjs slimerjs.py]
    end
    bin.install_symlink libexec/"slimerjs"
  end

  def caveats; <<-EOS.undent
    The configuration file was installed in:
      #{libexec}/application.ini
    EOS
  end

  test do
    ENV["SLIMERJSLAUNCHER"] = "/nonexistent"
    assert_match "Set it with the path to Firefox", shell_output("#{bin}/slimerjs test.js", 1)
  end
end
