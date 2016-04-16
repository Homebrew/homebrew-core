class TypesafeActivator < Formula
  desc "Tools for working with Typesafe Reactive Platform"
  homepage "https://typesafe.com/activator"
  url "https://downloads.typesafe.com/typesafe-activator/1.3.9/typesafe-activator-1.3.9-minimal.zip"
  version "1.3.9"
  sha256 "a418cdc7f204aca9cc8777df6d3a18c1bae1157fd972d60d135fce43e217cd64"

  bottle :unneeded

  def install
    rm Dir["bin/*.bat"] # Remove Windows .bat files
    libexec.install Dir["libexec/*"]
    bin.install Dir["bin/*"]
    chmod 0755, bin/"activator"
  end
end
