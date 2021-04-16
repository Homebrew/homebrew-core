require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.3.1.tgz"
  sha256 "9d78a92e8feacf9b94973ea097189a1607e9a6e7c81f1b16da16f78fb1d0ea77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "509c84a18de66f706451e386a6eeec61ea05dfd53009d542524e8aff7a5c821d"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3e765c42beb7ded32fcd94b79db1cc6af5658f4e0de805f9c023f3f07b2812d"
    sha256 cellar: :any_skip_relocation, catalina:      "f3e765c42beb7ded32fcd94b79db1cc6af5658f4e0de805f9c023f3f07b2812d"
    sha256 cellar: :any_skip_relocation, mojave:        "f3e765c42beb7ded32fcd94b79db1cc6af5658f4e0de805f9c023f3f07b2812d"
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
