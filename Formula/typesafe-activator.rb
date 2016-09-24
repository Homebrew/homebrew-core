class TypesafeActivator < Formula
  desc "Tools for working with Lightbend Reactive Platform"
  homepage "https://www.lightbend.com/community/core-tools/activator-and-sbt"
  url "https://downloads.typesafe.com/typesafe-activator/1.3.10/typesafe-activator-1.3.10-minimal.zip"
  version "1.3.10"
  sha256 "15352ce253aa804f707ef8be86390ee1ee91da4b78dbb2729ab1e9cae01d8937"

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
