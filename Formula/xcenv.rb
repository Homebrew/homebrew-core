class Xcenv < Formula
  desc "Xcode version manager"
  homepage "http://xcenv.org"
  url "https://github.com/xcenv/xcenv/archive/v1.1.0.tar.gz"
  sha256 "3a08afad39bf8243769b7aa49597688a8418ded9c229f672a3af8b007db4d331"
  head "https://github.com/xcenv/xcenv.git"

  bottle do
    cellar :any_skip_relocation
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
