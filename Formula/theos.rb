class Theos < Formula
  desc "Cross-platform tools for developing software for iOS and other platforms"
  homepage "https://theos.dev"
  license "GPL-3.0-or-later"
  head "https://github.com/theos/theos.git", branch: "master"

  stable do
    url "https://github.com/theos/theos.git",
      branch:   "master",
      revision: "97a91fe9a4a7d3391f50923cc2be910ed81f75be"
    version "2.6"
  end

  depends_on "ldid"
  depends_on :macos
  depends_on :xcode
  depends_on "xz"

  skip_clean "include", "lib"

  def install
    inreplace "vendor/nic/bin/nic.pl", "FindBin::Bin", "FindBin::RealBin"
    inreplace "vendor/nic/bin/nic.pl", "\"vendor", "\"../../vendor"
    inreplace "vendor/nic/bin/nic.pl", "\"templates", "\"../../templates"
    inreplace "vendor/nic/bin/nic.pl", "\"mod", "\"../../mod"
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
