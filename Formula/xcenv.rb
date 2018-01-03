class Xcenv < Formula
  desc "Xcode version manager"
  homepage "http://xcenv.org"
  url "https://github.com/xcenv/xcenv/archive/v1.1.1.tar.gz"
  sha256 "9426dc1fa50fba7f31a2867c543751428768e0592e499fb7724da8dae45a32ec"
  head "https://github.com/xcenv/xcenv.git"

  bottle :unneeded

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
