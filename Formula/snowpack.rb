require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.3.3.tgz"
  sha256 "b73dddf3b8785e600243372df72d72e4206a27c431fe01a4374685b75a5548f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10cce5587fb3e0a174f415ba71c03df22475f6c32288ff9d75067c8a3efbb20e"
    sha256 cellar: :any_skip_relocation, big_sur:       "98fdb3168bfdc6bb4863dad3a0a41934e99c8f814e91545d80efbf8784074203"
    sha256 cellar: :any_skip_relocation, catalina:      "98fdb3168bfdc6bb4863dad3a0a41934e99c8f814e91545d80efbf8784074203"
    sha256 cellar: :any_skip_relocation, mojave:        "5427bb03393e410f96825ab5c7c53b0b106d026a1df2d7561623855a6a195b99"
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
