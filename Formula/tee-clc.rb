class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere command-line Client"
  homepage "https://java.visualstudio.com/Docs/tools/eclipse"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.123.0/TEE-CLC-14.123.0.zip"
  sha256 "93fbf2372c7c719b41fe243fa3cef8ea1fa6b1e6dfb84990ad8664bbdbbb262b"

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
    ENV["TF_ADDITIONAL_JAVA_ARGS"] = "-Duser.home=#{ENV["HOME"]}"
    (testpath/"test.exp").write <<-EOS.undent
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
