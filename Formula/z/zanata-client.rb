class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/4.6.2/zanata-cli-4.6.2-dist.tar.gz"
  sha256 "6d4bac8c5b908abf734ff23e0aca9b05f4bc13e66588c526448f241d90473132"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4e9a444168ef8759f044a71501e69d0d5f5d8e22dd29038bc8f784751341aa8d"
  end

  # Deprecated since:
  # * No arm64 macOS support: https://docs.brew.sh/Support-Tiers#future-macos-support
  # * Still needs OpenJDK 8
  deprecate! date: "2025-09-25", because: :unmaintained
  disable! date: "2026-09-25", because: :unmaintained

  depends_on "openjdk@8" # https://github.com/Homebrew/homebrew-core/issues/33480

  on_macos do
    depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  end

  def install
    libexec.install Dir["*"]
    (bin/"zanata-cli").write_env_script libexec/"bin/zanata-cli", Language::Java.java_home_env("1.8")
    bash_completion.install libexec/"bin/zanata-cli-completion"
  end

  test do
    output = shell_output("#{bin}/zanata-cli --help")
    assert_match "Zanata Java command-line client", output
  end
end
