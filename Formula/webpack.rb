require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.27.1.tgz"
  sha256 "c8276046c671c22f7ec99d86104c66bb8151ceb6fb11a4d8fc79fa32824bcc58"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "0c03a18bb40b3a2bb83b0b1ce7beef50b9f292049c7e5071cd3d466008cfcd43" => :mojave
    sha256 "5fcc5a567eebb58c679ab7d42d3daf52c26d16e8fb47fe96e001eb544a8125b3" => :high_sierra
    sha256 "867c05b9b7a2851d0b5238537e43d2e52dff4bc4b85612ac44fec41eb86358d7" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.1.2.tgz"
    sha256 "135962a43cdec4d24f68925c32e4daea600d6433d7b8fb912a9709a65712411e"
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
