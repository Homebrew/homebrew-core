require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.20.0.tgz"
  sha256 "c82c224958ceb8a5e3bd8067f26f6f4d03c5188e8e075ada72a6dc97ebda06b8"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "56c37483e5386eaad59fc5f64a3768b6192ff5c58a2c3cca237e69613e2660f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e77addb434e359b4fb3351b70f4467cd3ebd7e0261e909f5f18be550030376a"
    sha256 cellar: :any_skip_relocation, catalina: "be47933d56039c43f461d068b0983edc082fdc72ab334f908674163571ca4137"
    sha256 cellar: :any_skip_relocation, mojave: "c995019b273c1ad7ea13d9965eaabc434da09249a709eb1b0864c09de406e517"
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
