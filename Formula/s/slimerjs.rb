class Slimerjs < Formula
  desc "Scriptable browser for Web developers"
  homepage "https://slimerjs.org/"
  url "https://github.com/laurentj/slimerjs/archive/1.0.0.tar.gz"
  sha256 "6fd07fa6953e4e497516dd0a7bc5eb2f21c68f9e60bdab080ac2c86e8ab8dfb2"
  license "MPL-2.0"
  head "https://github.com/laurentj/slimerjs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8885664d7813c68ee458bf887d4e52ccf8164a05bd89d8f2a7e82a3a5c6396b7"
  end

  def install
    ENV["TZ"] = "UTC"
    cd "src" do
      system "zip", "-o", "-X", "-r", "omni.ja", "chrome/", "components/",
        "modules/", "defaults/", "chrome.manifest", "-x@package_exclude.lst"
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
