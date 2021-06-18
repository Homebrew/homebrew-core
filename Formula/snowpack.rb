require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.5.9.tgz"
  sha256 "f23bfded383f0112c2e394f6e8db28d8f5451dbf55c246ad521483edcc5f5605"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b2506e8315d17da8e79f143e2206ae16b4529cddc580939b38ae6d2c81abb201"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c16a2e1a5285e20dddf111b5db34b01940a5bf2c76ffb3d99ec9163c1891d2f"
    sha256 cellar: :any_skip_relocation, catalina:      "2c16a2e1a5285e20dddf111b5db34b01940a5bf2c76ffb3d99ec9163c1891d2f"
    sha256 cellar: :any_skip_relocation, mojave:        "2c16a2e1a5285e20dddf111b5db34b01940a5bf2c76ffb3d99ec9163c1891d2f"
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
