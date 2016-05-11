class FirefoxRequirement < Requirement
  fatal true
  cask "firefox"

  def self.firefox_installation
    paths = ["~/Applications/FirefoxNightly.app", "~/Applications/Firefox.app",
             "/Applications/FirefoxNightly.app", "/Applications/Firefox.app",
             "~/Applications/FirefoxDeveloperEdition.app",
             "/Applications/FirefoxDeveloperEdition.app"]
    paths.find { |p| File.exist? File.expand_path(p) }
  end

  satisfy(:build_env => false) { FirefoxRequirement.firefox_installation }

  def message
    "Firefox must be available."
  end
end

class Slimerjs < Formula
  desc "Scriptable browser for Web developers"
  homepage "https://slimerjs.org/"
  url "https://download.slimerjs.org/releases/0.10.0/slimerjs-0.10.0.zip"
  sha256 "80b8008d9d8592e55e2744e1842139e33498221c2a78648fea1bdd0592231afb"
  head "https://github.com/laurentj/slimerjs.git"

  devel do
    url "https://download.slimerjs.org/nightlies/latest-slimerjs-master/slimerjs-0.10.0pre.zip"
    sha256 "dec4c1b591aed9ee0562aaa9f1901eb6d9f8904db4d51f8550f98d25be9d188f"
  end

  bottle :unneeded

  # Min supported OS X version by Firefox is 10.6.
  depends_on :macos => :leopard
  depends_on FirefoxRequirement

  def install
    if build.head?
      cd "src" do
        system "zip", "-r", "omni.ja", "chrome/", "components/", "modules/",
                      "defaults/", "chrome.manifest", "-x@package_exclude.lst"
        libexec.install %w[application.ini omni.ja slimerjs slimerjs.py]
      end
    else
      libexec.install %w[application.ini omni.ja slimerjs slimerjs.py]
    end
    bin.install_symlink libexec/"slimerjs"
  end

  def caveats
    s = ""

    if (firefox_installation = FirefoxRequirement.firefox_installation)
      s += <<-EOS.undent
        You MUST provide an installation of Mozilla Firefox and set
        the environment variable SLIMERJSLAUNCHER pointing to it, e.g.:

        export SLIMERJSLAUNCHER=#{firefox_installation}/Contents/MacOS/firefox
        EOS
    end
    s += <<-EOS.undent

      Note: If you use SlimerJS with an unstable version of Mozilla Firefox (>38.*)
      you may have to change the [Gecko]MaxVersion in #{libexec}/application.ini
    EOS

    s
  end

  test do
    ENV.delete "SLIMERJSLAUNCHER"
    assert_match "Set it with the path to Firefox", shell_output("#{bin}/slimerjs", 1)
  end
end
