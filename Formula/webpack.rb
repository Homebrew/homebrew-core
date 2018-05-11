require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.8.2.tgz"
  sha256 "04c1b95f4a9daa809c6be2e579abde6b77a611c9a12ec1bbd8750b6deb953787"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "0e4dbe75d429f6a7df60ccc2433f62ce50ece2671e439d5eaf45df2de4230ba1" => :high_sierra
    sha256 "0ae716cb3fcea862d185b9c55005b404b9ad4cc41280da5f8c093b01619e5f6d" => :sierra
    sha256 "03a09a25791c8ccca3c33369f8d7f626b99defaadbc19e84b3bd7286fde22bc3" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.1.3.tgz"
    sha256 "5587e4d8d14a122ee5130c27a5628f46774dfad432dd32175e4132bd6c3d345d"
  end

  def install
    (buildpath/"cli/node_modules/webpack").install Dir["*"]
    (buildpath/"cli").install resource("webpack-cli")

    cd buildpath/"cli" do
      # declare webpack as a bundledDependency of webpack-cli
      pkg_json = JSON.parse(IO.read("package.json"))
      pkg_json["dependencies"]["webpack"] = version
      pkg_json["bundledDependencies"] = ["webpack"]
      IO.write("package.json", JSON.pretty_generate(pkg_json))

      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    end

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
