class TypesafeActivator < Formula
  desc "Tools for working with Lightbend Reactive Platform"
  homepage "https://www.lightbend.com/community/core-tools/activator-and-sbt"
  url "https://downloads.typesafe.com/typesafe-activator/1.3.12/typesafe-activator-1.3.12-minimal.zip"
  sha256 "d5037bcc2793011a03807a123035d2b3dafde32bcf0fab9112cb958a59ad9386"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm Dir["bin/*.bat"] # Remove Windows .bat files
    libexec.install Dir["libexec/*"]
    bin.install Dir["bin/*"]
    chmod 0755, bin/"activator"
  end

  test do
    out = shell_output("#{bin}/activator -help", 1).split("\n")[0]
    assert_equal "Usage: activator [options]", out
  end
end
