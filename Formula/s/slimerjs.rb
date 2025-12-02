class Slimerjs < Formula
  desc "Scriptable browser for Web developers"
  homepage "https://slimerjs.org/"
  url "https://github.com/laurentj/slimerjs/archive/refs/tags/1.0.0.tar.gz"
  sha256 "6fd07fa6953e4e497516dd0a7bc5eb2f21c68f9e60bdab080ac2c86e8ab8dfb2"
  license "MPL-2.0"
  head "https://github.com/laurentj/slimerjs.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9e5d50e6a167227e13f88b3d46bc768854aa70b897597d3ab5f9389bff389cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "28448d431b342918fa343fd2fc2d89663927395d35e0f5c20d16f8038c2f298e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67d28bb3031d3480c7d871cc10299334f80046ddb665db2445faedd82c43f26a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67d28bb3031d3480c7d871cc10299334f80046ddb665db2445faedd82c43f26a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67d28bb3031d3480c7d871cc10299334f80046ddb665db2445faedd82c43f26a"
    sha256 cellar: :any_skip_relocation, sonoma:         "67d28bb3031d3480c7d871cc10299334f80046ddb665db2445faedd82c43f26a"
    sha256 cellar: :any_skip_relocation, ventura:        "67d28bb3031d3480c7d871cc10299334f80046ddb665db2445faedd82c43f26a"
    sha256 cellar: :any_skip_relocation, monterey:       "67d28bb3031d3480c7d871cc10299334f80046ddb665db2445faedd82c43f26a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bc310525c420056205fcf75a9398dbc1a67016af07bb8a032767da518d6e185f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d942f6e440cc015898a1d2c114714fe133ec4aff583043f2e35c9c404a9e621c"
  end

  uses_from_macos "zip" => :build

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
