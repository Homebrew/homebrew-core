require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.17.0.tgz"
  sha256 "42578ca18aa61be9c1ccf91961487d3dd882cabf02099ff73fe4b9c9d23cfc7b"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "b93d68289098ac53d21b05530e5eedf549c5bb2dbfa165cdd8da14b4334c69d2" => :high_sierra
    sha256 "7d4f8a1b8130eb61e0377f7a44319c577689b9b29df84885414622f3ae85235b" => :sierra
    sha256 "60b1118582edce61e3af736c9db5d0715ceba8f8fa68a07c9439158c3ae99286" => :el_capitan
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
