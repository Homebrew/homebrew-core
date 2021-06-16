require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.5.8.tgz"
  sha256 "8046a314eea2b10c611914e5a58f7797c1f8bb5351e676787a610adf97615130"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e17ecfe9352a5bb2a6d69839305d34608f5e8eb385ae3e364e8b03b44e181fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf4db97de7d97a1e8ea92c3bfc0c7e2232c56cc5ec769f1526c7a8a0a44525ac"
    sha256 cellar: :any_skip_relocation, catalina:      "cf4db97de7d97a1e8ea92c3bfc0c7e2232c56cc5ec769f1526c7a8a0a44525ac"
    sha256 cellar: :any_skip_relocation, mojave:        "cf4db97de7d97a1e8ea92c3bfc0c7e2232c56cc5ec769f1526c7a8a0a44525ac"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "work" do
      system bin/"snowpack", "init"
      assert_predicate testpath/"work/snowpack.config.js", :exist?

      inreplace testpath/"work/snowpack.config.js",
        "  packageOptions: {\n    /* ... */\n  },",
        "  packageOptions: {\n    source: \"remote\"\n  },"
      system bin/"snowpack", "add", "react"
      deps_contents = File.read testpath/"work/snowpack.deps.json"
      assert_match(/\s*"dependencies":\s*{\s*"react": ".*"\s*}/, deps_contents)

      assert_match "Build Complete", shell_output("#{bin}/snowpack build")
    end
  end
end
