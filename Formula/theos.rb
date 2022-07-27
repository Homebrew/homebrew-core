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

  depends_on "ldid"
  depends_on :macos
  depends_on :xcode
  depends_on "xz"

  skip_clean "include", "lib"

  def install
    inreplace "vendor/nic/bin/nic.pl", "\"vendor", "\"opt/#{name}/vendor"
    inreplace "vendor/nic/bin/nic.pl", "\"templates", "\"opt/#{name}/templates"
    inreplace "vendor/nic/bin/nic.pl", "\"mod", "\"opt/#{name}/mod"
    rm_rf [Dir["bin/*update*"], "include/.keep", "lib/.keep", "sdks"]

    prefix.install Dir["*"]
    mkdir pkgetc/"sdks" unless (pkgetc/"sdks").exist?
    prefix.install_symlink pkgetc/"sdks"
  end

  def caveats
    <<~EOS
      You must add the following line in your .profile/.bashrc/.zshrc:
        export THEOS="#{opt_prefix}"

      And you must download and place Theos patched SDKs in this folder:
        #{pkgetc}/sdks
    EOS
  end

  test do
    assert_match "Use of uninitialized value", shell_output("#{bin}/nic.pl 2>&1 <<< 17", 1)
  end
end
