require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.17.0.tgz"
  sha256 "0e65fbdbd6e9c5a281e75665ffbbc35480f51a8cd0c0bea77b82f7d850e91939"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "05c73b5ab958f9ec6e2f6c2a63d51394475cc04df54cf8db79b5b3408ae7ae3e" => :big_sur
    sha256 "aaed1d41752ea14fbf9edfc9a08f8e34df4f873c0648cfe211f37330605e257b" => :arm64_big_sur
    sha256 "c4e9f3cd306bade84b73aa49bf05e60ae04eaff1511e52b35096d505efb8f37b" => :catalina
    sha256 "aa8449741d5f6d802aa84f47a3f38d5dd09c2c8af5baae3183ad22dbaa40ec32" => :mojave
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.4.0.tgz"
    sha256 "11fcc682d0a7ec669415518b80c874be348d865997bddf8a2b8cd801918157ae"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production", "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
