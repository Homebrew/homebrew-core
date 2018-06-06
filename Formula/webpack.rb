require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.11.1.tgz"
  sha256 "971e29048d4fa209392aa943538501f4017882ba04a91ce5bf4e98a29ae485df"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "59d535c978e99922d62e44dd04d929b9381664aec1c04c72a632ea1f39578bd7" => :high_sierra
    sha256 "8cd210b2308a2aeb394fc825220b93015fdb3682c83cdbf192f697564337c53b" => :sierra
    sha256 "c0ab561a064bd421e17d3f3247f513fb9b15412929aa11fe3bb5894f934cca14" => :el_capitan
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
