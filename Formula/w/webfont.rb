class Webfont < Formula
  desc "Generator of fonts from SVG icons, with TTF encoding and WOFF/WOFF2 decoding"
  homepage "https://webfont.js.org/"
  url "https://registry.npmjs.org/webfont/-/webfont-12.7.0.tgz"
  sha256 "11eb5d46f7034bfd43b6040791757137b3711732ad0d109e54e559321e9ffa20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2ad6347d1fb6ada09b636f93050ee1c2772b9313e362112a92c834945b27a8f"
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
