require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.4.0.tgz"
  sha256 "28e909cfba685ede729c9ba2d41258b4bfcb29f973a722e3d0f58e0fbb8828d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7be389b3ad57779f1a117ad380c559fe2e476a75d3aacc9f76c29b4a7c6e515a"
    sha256 cellar: :any_skip_relocation, big_sur:       "13b00805f9fef1cd75c14e1a6346ea2e58d1aa0b246b039deab1733e42066813"
    sha256 cellar: :any_skip_relocation, catalina:      "13b00805f9fef1cd75c14e1a6346ea2e58d1aa0b246b039deab1733e42066813"
    sha256 cellar: :any_skip_relocation, mojave:        "13b00805f9fef1cd75c14e1a6346ea2e58d1aa0b246b039deab1733e42066813"
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
