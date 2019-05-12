require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.31.0.tgz"
  sha256 "489e757a7296ae29846e0f8d08295999ce1d77b6744407c34216cb9a8b80aaab"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "6a1e3f5ff141ca9a21142673c3c02204804114e52641a8e9fafd5216550ee349" => :mojave
    sha256 "9e21021cb905b24cd1a393469e838ec7f5e1aa2e353b2f7758410005cbd7e519" => :high_sierra
    sha256 "8bf6eb79ffc211ef3a03238b363e7245fac0e35ae90cd89123f0e2a773a4b9e1" => :sierra
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
