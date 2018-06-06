require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.11.1.tgz"
  sha256 "971e29048d4fa209392aa943538501f4017882ba04a91ce5bf4e98a29ae485df"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "b0fe7cf8150d80ba5a0b1f295acc74a3aa84b7f6434d274a977152e701752793" => :high_sierra
    sha256 "be826d74f53d9c8d1fbad7a683970ab9907e82e0cc0c60a0e60eabbf47a0c4f6" => :sierra
    sha256 "16099138d4f37ac0b23d92a4de14026a335590e693dd7aa548cc8c48ac632476" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.0.2.tgz"
    sha256 "3908442791e4b39c22ad13ba4226a3956637cb821c0c5859bfea60f3c38ec34e"
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
