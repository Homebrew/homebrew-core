require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.16.0.tgz"
  sha256 "eb8e81ef1b23d2b60b29effa39f280288d276b120cb302f981c7b0662907e5e5"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "eb00d91abb899278b2ca0b5c4d564d93d5dee34ad078b5f433376a0663619d17" => :high_sierra
    sha256 "8b993c252135e137818d099efddab1a977493fa5cc5a9e04966ae12a4f3ea530" => :sierra
    sha256 "4849a768774a6edb86849326ac5b665658eb0a2cb9861b05e7e9e844c280d64b" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.0.8.tgz"
    sha256 "bad0d3c4a793e865217343aa60395cb4fa6309fcca1117554811fba723a8bb64"
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
