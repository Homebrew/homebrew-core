require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.2.0.tgz"
  sha256 "d7fbe8816839c59bca6828022315adece37bcfa5692ce6d7a0bd713651c25951"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "84aa1cc77ef46f0e3f0027326a9112e14d23984738704abcafd870365f8e7c56" => :sierra
    sha256 "7439753703d6e4e9babc626251f991a0a328bc35bd9d85bcc7dc0395eacd817a" => :el_capitan
    sha256 "6ad8a86daa0cfdd35888dc7274fb28791028a027e572e5a0279215bda0c2605f" => :yosemite
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
