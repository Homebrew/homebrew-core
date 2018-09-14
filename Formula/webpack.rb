require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.19.0.tgz"
  sha256 "1a5b2cce6b5db475ccc469685cbc07aefe8bca5f68c17f7b87df202df951d7f1"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "835ba1cadc92fcc9656ec0e45729baa12f93efacb9e9e90bda3104c9fad24e94" => :mojave
    sha256 "8fc8dd6dbf4a9bd810d1ab382ec421ca63b6b61a9077408ede9bab9e61a1bc0f" => :high_sierra
    sha256 "caf8ce148ea21de5b79e8d3c1c815b779d5b31502f0214198e0b16bb28a5fb2b" => :sierra
    sha256 "9f9cf769540ede5d9e1e365f07b566a1ee13e132cecebecdb8be16d9177f62a0" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.1.0.tgz"
    sha256 "813af78013aed28a967d2227c17b9c81c4809ed68b4f324a22e703167ea01e73"
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
