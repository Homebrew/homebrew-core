require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.1.0.tgz"
  sha256 "7f502bbf1cb60aedd317ceb9474bd6fd718134a9b57ef24025e20baf718e78e1"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "4a959a8204df945850f4cd6713edff47ddcc89c36e3cb4204c4492f1e563e9b8" => :high_sierra
    sha256 "0348618ee6c81fb9e096198ef6e9e898b5c43fe6bcd563f376bb8ff468f2a539" => :sierra
    sha256 "12f3de3c3cab637647c9ea67b107590eb9f145f67bff4586f23e7f240413abf9" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.0.10.tgz"
    sha256 "d761469105659a480a2f001384691b80babd41c3054633ad582c620258f1d1c6"
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
