class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman",
      :using    => :git,
      :tag      => "v1.2.0",
      :revision => "6e6178be65665ce84b9e2c9b100c59846e75f494"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4440913a564ca0f032eaa0c385c13e71f425a41d7aff52506b90118984b8e32" => :catalina
    sha256 "c2c7e787dcd4cabe6b278ee40e122c2933978aa0518de20f4fc49a4ff59a06c2" => :mojave
    sha256 "c44fa4bfe8e660829cf927cdb847b8d7024823e3881f14d41174368af48bdf14" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    system "./build"
    bin.install "./talisman_darwin_amd64" => "talisman"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
