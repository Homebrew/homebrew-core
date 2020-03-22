class Slimerjs < Formula
  desc "Scriptable browser for Web developers"
  homepage "https://slimerjs.org/"
  url "https://github.com/laurentj/slimerjs/archive/1.0.0.tar.gz"
  sha256 "6fd07fa6953e4e497516dd0a7bc5eb2f21c68f9e60bdab080ac2c86e8ab8dfb2"
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

  def caveats
    <<~EOS
      The configuration file was installed in:
        #{libexec}/application.ini
    EOS
  end

  test do
    ENV["SLIMERJSLAUNCHER"] = "/nonexistent"
    assert_match "Set it with the path to Firefox", shell_output("#{bin}/slimerjs test.js", 1)
  end
end
