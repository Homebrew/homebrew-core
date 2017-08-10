require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.5.2.tgz"
  sha256 "7e1c877dbecda530ab5bf1fe57e1da250dddc5798c1fa690145adb3b3c725482"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "cf64187166730e356d68a293478a4f1b5b2a9475f7a1dcb4d7e8429641df7ae6" => :sierra
    sha256 "0341eeffd6faaa1a5e7ddc8c5f24b482fe144c02e3a2076e6fca145a56cf1d49" => :el_capitan
    sha256 "5508060bfc8bfeb6d85211c0942fe6fa96de9c0374b167a2915dd58fc857127f" => :yosemite
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
