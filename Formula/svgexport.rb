require "language/node"

class Svgexport < Formula
  desc "SVG to PNG/JPEG export tool"
  homepage "https://github.com/shakiba/svgexport"
  url "https://registry.npmjs.org/svgexport/-/svgexport-0.3.2.tgz"
  sha256 "878f2faf89d67e9a73e32101ea486e5123a6bc6137278a403da8c7bc7743c113"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath/"test.svg"
    system bin/"svgexport", testpath/"test.svg", testpath/"test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
