require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.5.5.tgz"
  sha256 "11598086b1f673d3349c7607c698c5165360e1647f027945e00287affee3f4d5"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "5dbab9a1519c4a64cbda8b8a49802ac239930c6d9d6c3874802d940725320448" => :sierra
    sha256 "ff8f6b8c4d2618890ddeff1de8b6428a1a7bb385277f121f9c24b8e3899790d8" => :el_capitan
    sha256 "ce1928b3f8c4e1b2a54a3ec7d6b46913bc646e773864c78e47e95580c5db455e" => :yosemite
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
