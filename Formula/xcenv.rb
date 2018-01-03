class Xcenv < Formula
  desc "Xcode version manager"
  homepage "http://xcenv.org"
  url "https://github.com/xcenv/xcenv/archive/v1.1.1.tar.gz"
  sha256 "9426dc1fa50fba7f31a2867c543751428768e0592e499fb7724da8dae45a32ec"
  head "https://github.com/xcenv/xcenv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "801f48f671d9658695f7cdb00c1de4f49bff7231856112b597c398f744cc4264" => :high_sierra
    sha256 "000e0d3d363de9398ba5655f5536cb817a6f1019f2679b4469556d86bf012a4b" => :sierra
    sha256 "000e0d3d363de9398ba5655f5536cb817a6f1019f2679b4469556d86bf012a4b" => :el_capitan
    sha256 "000e0d3d363de9398ba5655f5536cb817a6f1019f2679b4469556d86bf012a4b" => :yosemite
  end

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
