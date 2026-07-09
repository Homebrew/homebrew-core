class Webfont < Formula
  desc "Generator of fonts from SVG icons, with TTF encoding and WOFF/WOFF2 decoding"
  homepage "https://webfont.js.org/"
  url "https://registry.npmjs.org/webfont/-/webfont-12.5.0.tgz"
  sha256 "f024d129de480429e81668fa3821859af3784a5aa0f6714ebe236d8520c13ce3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cbb5864676ee483b199762724623788491cd885ad3a38fe478edb7d04728f4e9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"icon.svg").write <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M2 2h12v12H2z"/></svg>
    SVG

    system bin/"webfont", testpath/"icon.svg", "-d", testpath, "-f", "woff2"
    assert_path_exists testpath/"webfont.woff2"
    assert_match version.to_s, shell_output("#{bin}/webfont --version")
  end
end
