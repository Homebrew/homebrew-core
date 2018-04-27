class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere command-line Client"
  homepage "https://github.com/Microsoft/team-explorer-everywhere"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.134.0/TEE-CLC-14.134.0.zip"
  sha256 "af4b7123a09475ff03a3f5662df3de614df2f4acc33df16cdab307b5fb6d7dc7"

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
