class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere command-line Client"
  homepage "https://java.visualstudio.com/Docs/tools/eclipse"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.123.1/TEE-CLC-14.123.1.zip"
  sha256 "868416c59cffd5d84118ad35b164c09c1a8980737de8de2f64dd727c7a11ad0a"

  bottle :unneeded

  depends_on :java => "1.6+"

  conflicts_with "tiny-fugue", :because => "both install a `tf` binary"

  def install
    libexec.install "tf", "lib"
    (libexec/"native").install "native/macosx"
    bin.write_exec_script libexec/"tf"

    prefix.install "ThirdPartyNotices.html"
    share.install "help"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/tf workspace
      set timeout 5
      expect {
        timeout { exit 1 }
        "workspace could not be determined"
      }

      spawn #{bin}/tf eula
      expect {
        "MICROSOFT TEAM EXPLORER EVERYWHERE" { exit 0 }
        timeout { exit 1 }
      }
    EOS
    system "expect", "-f", "test.exp"
  end
end
