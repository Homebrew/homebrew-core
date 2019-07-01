require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.35.2.tgz"
  sha256 "8d234567cd3adf8dba3e5a25aa50aa344cabff741c2712bedb26001741e0f6a8"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "57fb0be0d0775b04d4e70d1e2cfa3488289563bb72425874c4486e5ee72acf50" => :mojave
    sha256 "d9bb8db3daf20835a8c2c64a8120b03616e2e311c08781761424597687712919" => :high_sierra
    sha256 "c80324c5ec4612e03bbb61029402c88179057fe3e071e159bef6f560b99278e5" => :sierra
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
