require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.38.0.tgz"
  sha256 "ec86c13fa34fa93f008867de38f4603d66bb1e590459d3e8df5f0214f44020c0"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "5a07c88b753c51884513c45dda803a7f6964f7b3c96380cc729476a6f45ce693" => :mojave
    sha256 "e8dee39407fd40704ac606fa4fe0fff63dba48c13ff661332df66bd8f006e364" => :high_sierra
    sha256 "7ed41e39615e24b7639418f9d3e9464cc58ac0ab71428342a7054fa0eb60d4ef" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.5.tgz"
    sha256 "60254336b5994487f58712714b1b1a475e74dc1d0b3b3e609086096f445b1818"
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
