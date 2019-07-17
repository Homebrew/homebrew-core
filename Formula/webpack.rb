require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.36.1.tgz"
  sha256 "c77c2c3f326b66f25696af41985fc91683b39a1166691a405355bf4ae71d9bb3"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "2ba6a626fa0e3a44f2926765a4b9525d5c603c53d0744d0c1b5884f82f8e7c10" => :mojave
    sha256 "1f4100857abb2c897655256edc7b373dcd27a83efd65ff861c22d953f1d28b3f" => :high_sierra
    sha256 "f6b9e80369a01ff28922f422b2a6268351cbfc67dfca8803cce43c3a90cf8175" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.5.tgz"
    sha256 "60254336b5994487f58712714b1b1a475e74dc1d0b3b3e609086096f445b1818"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundledDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "--output=bundle.js"
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
