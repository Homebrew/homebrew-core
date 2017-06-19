require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.0.0.tgz"
  sha256 "290be3ffe1210b09e057afdc062e80ad6c6041d43ecc26dc4d525871eb1900e0"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "901c4555ec424ec50611d64fb728beeacfd7fda3f08697b658b9d2da33ed8c3f" => :sierra
    sha256 "45d6a5c4e25fa56ac3c9bcecf6245851f1571806f1f352b25a077efeb0ae4091" => :el_capitan
    sha256 "8acdbf1f5e927c65c8fb9742b52bb6132b8b68231ae50dfb686871ee391c97e8" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"index.js").write <<-EOS.undent
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "bundle.js"
    assert File.exist?("bundle.js"), "bundle.js was not generated"
  end
end
