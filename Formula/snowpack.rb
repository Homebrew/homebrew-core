require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.8.6.tgz"
  sha256 "f6fde2514d4dad5f214d28dc0f4efcc7396efd72b6ee41fc0daa7178e6d1f80c"
  license "MIT"

  bottle do
    sha256                               arm64_big_sur: "77eea0b984d239d3a6cdfa31a1eaa8e13c1f93ba415c945843bdabdaec470f4f"
    sha256                               big_sur:       "2dc4453caa37175ae40898b2c10e49db9c75cf0b2791111cd66bcea2ff537e0a"
    sha256                               catalina:      "543b6757d38abf90f2921307a25a644e42ba0903aac87040a62cab54b8adae07"
    sha256                               mojave:        "8fd7d598faa02e46f7b24d7f542b2f0f85b7d8dcaf378cfa48807dee53d86f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f9a3d9a8e7a73cb4e8b3738c5f0ddb4db9b6c572ff57d4e7864f4637b12d6a7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "work" do
      system "npm", "init", "-y"
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
