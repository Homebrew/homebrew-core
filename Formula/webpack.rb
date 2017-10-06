require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.6.0.tgz"
  sha256 "d130fa4812e4fcc967d9108c3e7fabb8f2b95d1b84358b809d82623b55a274e5"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "43da9ceb45e0291c1a411f9f58deaa0aa3fe76eaf636d17ffefa3df04265d945" => :high_sierra
    sha256 "064da79dd2b78cae78804e72c819fc67a983000857f7040f4ac49b4b5022d177" => :sierra
    sha256 "b03bf6d874732cde60170027a6b67ffb64c688d470cefc9f2ee006ff1a61de72" => :el_capitan
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
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
