require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.0.1.tar.gz"
  sha256 "1333b86493b4115692dc7013fa094ece9fb56be5001717c638b5a2547bff8959"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f6a6e2ac608863f5495c66e47d8032011c8a99dac308e70f570eef113f12212" => :high_sierra
    sha256 "d3b9bc6815642fa7ecbf426da793a527f36a77d9d826885c0939098307c31cf7" => :sierra
    sha256 "7c2371ae29c40d874ad2eb2d29cb1644921da4c8736a7add555e2b5eb8d290b4" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match /^<svg /, (testpath/"test.min.svg").read
  end
end
