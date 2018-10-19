require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.21.0.tgz"
  sha256 "c7c5f1057765db8f81696d97f6bc93b137bd8ef65abc9b820f77693b4f2b5c31"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "418f55f71a76a975ab4463889ffe7aa34984b35cdbfd8a58ef4451a0e89d42e3" => :mojave
    sha256 "ca3f89d9213bab6f7d701b925928ff4fbf52c5de618e903d497bb504505ad433" => :high_sierra
    sha256 "21789d2e4132af07f7609c32f33b2658fdd847f0d87066b9d8f490d58aa46097" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.1.2.tgz"
    sha256 "135962a43cdec4d24f68925c32e4daea600d6433d7b8fb912a9709a65712411e"
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
