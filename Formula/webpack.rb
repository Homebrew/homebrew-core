require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.1.1.tgz"
  sha256 "8ddd53c1c0471af5031ca2dbbaa85f4d15a25d84386bb0d86bc76a7a082c2e40"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "00534b4d4669e90c5ac0416a67031592cf46891b3ec31bb098ebae99b2afad3a" => :high_sierra
    sha256 "195c2389f40c548b19f10de0d8cb29d3661c950871bef4ce3dc921acdea7a73c" => :sierra
    sha256 "b6e8c0b220327e016a878abaf2851e5a1252879e5b3c7617ab2af97c07f51a97" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.0.11.tgz"
    sha256 "6e9443de4a4c5d380cae8ac7630873ef0df6e137bd38cbe00a29757771ffb426"
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
