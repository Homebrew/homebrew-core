require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.12.0.tgz"
  sha256 "e43c01ac24805ebd8a9d1e3e602f575c96258319cd1f5de30cc50641623e9c4c"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "b0fe7cf8150d80ba5a0b1f295acc74a3aa84b7f6434d274a977152e701752793" => :high_sierra
    sha256 "be826d74f53d9c8d1fbad7a683970ab9907e82e0cc0c60a0e60eabbf47a0c4f6" => :sierra
    sha256 "16099138d4f37ac0b23d92a4de14026a335590e693dd7aa548cc8c48ac632476" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.0.3.tgz"
    sha256 "f689a9cfc71e802a094b0218cbc93fd4417585ff29eaed533ae847c3565117c3"
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
