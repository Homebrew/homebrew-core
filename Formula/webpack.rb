require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.32.2.tgz"
  sha256 "6aacb0208e3ee47f61ec944e67f5a9facca6e65602492f1f345061a2854c83e2"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "8c4cbf10a53cdcd958bbedcbee4b3c02cba6dd67835fe5af1aeea266e7d2e422" => :mojave
    sha256 "f0cf000a57f103049820f1e71a59473d88c7195cc0da360f6f8b4ab2edf48c60" => :high_sierra
    sha256 "fc98ee09b592aa8a862d7ed8b6f92cb43b3570346ef13bbbe3baf39622702e94" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.2.tgz"
    sha256 "dcb31e31e1ffe79e97d51782a38459785f2ded99bc15467ffe35f9ac33146df4"
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
