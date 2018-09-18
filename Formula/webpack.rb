require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.19.1.tgz"
  sha256 "166f1848683ac9b599f74da922576f8b0c847d5b92e50af53240a84b1ea8e935"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "654a3c54309f7c93b896eff5b5d2f4d527725b51c1e23df9bea8c9ef29b374de" => :mojave
    sha256 "0dc6e8fb727b6938a0403d389564969cc6a90c9af0446165dace606710383bdd" => :high_sierra
    sha256 "c10af7a8dbf83ada355e1d958c18b3898d67a80bfa05dd814c304478fbe5e98f" => :sierra
    sha256 "b6a5156669545d24c1862ef941447ca97e05c0ebd1428133a3e6a7c5dddab8c5" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.1.0.tgz"
    sha256 "813af78013aed28a967d2227c17b9c81c4809ed68b4f324a22e703167ea01e73"
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
