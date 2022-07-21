class Theos < Formula
  desc "Cross-platform tools for developing software for iOS and other platforms"
  homepage "https://theos.dev"
  license "GPL-3.0-or-later"
  head "https://github.com/theos/theos.git", branch: "master"

  stable do
    url "https://github.com/theos/theos.git",
      branch:   "master",
      revision: "e53ec51e92a3716def537c7ff1b5b2a86930700c"
    version "2.6"
  end

  keg_only "symlinking Theos makes it unusable"

  depends_on "ldid"
  depends_on :macos
  depends_on :xcode
  depends_on "xz"

  skip_clean "lib", "sdks"

  resource "sdks" do
    url "https://github.com/theos/sdks.git",
      branch:   "master",
      revision: "fd931ca723ee46994ad9f73c2f0929d1ab9732ca"
  end

  def install
    prefix.install Dir["*"]
    (prefix/"sdks").install resource("sdks")
    rm_rf lib/".keep"
  end

  def caveats
    <<~EOS
      To use Theos, please put the following in your .profile:
        export THEOS="#{opt_prefix}"
    EOS
  end

  test do
    assert_match "Use of uninitialized value", shell_output("#{bin}/nic.pl 2>&1 <<< 17", 1)
  end
end
