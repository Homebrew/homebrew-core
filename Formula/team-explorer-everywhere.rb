class TeamExplorerEverywhere < Formula
  desc "Run version control commands against a TFS server"
  homepage "http://go.microsoft.com/fwlink/?LinkId=242481"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.120.0/TEE-CLC-14.120.0.zip"
  sha256 "157389b282a00c0d2e33bfab61e88bb47acb7811facbc427b766ed19be1821ec"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    ENV["TF_CLC_HOME"] = libexec
    libexec.install Dir["#{buildpath}/*"]
    bin.install libexec/"tf"
    bin.env_script_all_files(libexec, :TF_CLC_HOME => ENV["TF_CLC_HOME"])
  end

  test do
    ENV["TF_ADDITIONAL_JAVA_ARGS"] = "-Duser.home=#{ENV["HOME"]}"
    (testpath/"test.exp").write <<-EOS
      spawn #{bin}/tf workspace
      expect "workspace could not be determined"
      spawn #{bin}/tf eula
      expect "MICROSOFT TEAM EXPLORER EVERYWHERE"
    EOS
    system "expect", "-f", "test.exp"
  end
end
