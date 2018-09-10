require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.18.0.tgz"
  sha256 "d65e4456cee5754574a63b17d33683ff88e1aec9bdd13b26d610db003b59371d"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "a1e00dd0c24052e2b271c8fcfc6ebbc244f5843ad6c9e273345752313b0bd9b1" => :mojave
    sha256 "b4d8ca4ca0be782708f3b8133f11a29b37078daefbe5224c758f13091aa8e229" => :high_sierra
    sha256 "b2fde6be5743b8d3554858b895a42dce7485d1d252bb3b1c47262cfe45b12e2e" => :sierra
    sha256 "55c6a77ccd5eff0e127de94d99d0a823e14e4d05d6b8f7c2512def92f06c48dc" => :el_capitan
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
