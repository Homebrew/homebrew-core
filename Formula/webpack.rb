require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.19.1.tgz"
  sha256 "166f1848683ac9b599f74da922576f8b0c847d5b92e50af53240a84b1ea8e935"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "b681cf51a834ee80f28b92314e7a6e95b61613f83cace50398e4a22493f641eb" => :mojave
    sha256 "ecdb9127e411ee5130ff82f3ad03f1d49fdd773090b35751bf02e57ea7150f19" => :high_sierra
    sha256 "0a58b63aab19f062d63cc595cd94ef691ac1d91c33730b9a0b02418a2607529a" => :sierra
    sha256 "328d09e9d83f0af68bc19e05c37f171a5bbed7867de5e195e16119b7f613facb" => :el_capitan
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
