require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.43.0.tgz"
  sha256 "66d201133b2278182102c7ab65ebddf7e5015e5ee886a3e390802a958496e1ec"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "25b973ccc5a05b6503fbc68f71002181cf96c985b1e5577a4487a837f1e463f8" => :catalina
    sha256 "7361818c7c5059b3df84ed03da81b03918ba872ec4de78619c8f3b019dca2ef7" => :mojave
    sha256 "954648057c93d77b6ff050705ad900d7861d7ff62a8ea8dfa6d9deb4b4a2794a" => :high_sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.11.tgz"
    sha256 "dace2e99dc7b819b4695c69c327a0da9f56f799f15d20346b22a6cc22c5fb794"
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
