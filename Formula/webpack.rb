require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.18.0.tgz"
  sha256 "d65e4456cee5754574a63b17d33683ff88e1aec9bdd13b26d610db003b59371d"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "70ab4eddfb9a768ce771f3e361ea023f1fc9bf8bad01a47f67542a0b43064752" => :mojave
    sha256 "c4614cb6dfcb5bda8422ffe3cd6ef141d7dc674a072b6670db7b43cb2bbf4281" => :high_sierra
    sha256 "db936008399d39e8d573036bd164f9c99b7541d037683d7fffa170c6890532d8" => :sierra
    sha256 "74f5e712c007ab1253af6722dbc3eb7cd53a202a694e8c6bb7f2704e4d0c9f5d" => :el_capitan
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
