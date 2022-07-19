class Theos < Formula
  desc "Cross-platform tools for developing software for iOS and other platforms"
  homepage "https://theos.dev"
  url "https://github.com/theos/theos.git",
    branch:   "master",
    revision: "e53ec51e92a3716def537c7ff1b5b2a86930700c"
  version "2.6"
  license "GPL-3.0-or-later"
  head "https://github.com/theos/theos.git", branch: "master"

  keg_only "symlinking Theos will make Theos unusable"

  depends_on "ldid"
  depends_on "xz"

  resource "sdks" do
    url "https://github.com/theos/sdks.git",
      branch:   "master",
      revision: "fd931ca723ee46994ad9f73c2f0929d1ab9732ca"
  end

  def install
    prefix.install Dir["*"]
    (prefix/"sdks").install resource("sdks")
  end

  test do
    assert_match "Use of uninitialized value", shell_output("#{bin}/nic.pl <<< 17 2>&1", 1)
  end
end
