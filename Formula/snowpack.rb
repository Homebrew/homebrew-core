require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.5.4.tgz"
  sha256 "4ee2f4f9323566f5e4b9431b188f89a344276ee288d730cfd6dc878f765d7f10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "514bf52b8ae95fa3d5c5d2ed4f38e8945eba8e38d2f0b0e44329d1b0a69aad1f"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b01e7e6bb639b68a33a3087db8cb10c476e2c8aa7957f20a18f214b70580979"
    sha256 cellar: :any_skip_relocation, catalina:      "5b01e7e6bb639b68a33a3087db8cb10c476e2c8aa7957f20a18f214b70580979"
    sha256 cellar: :any_skip_relocation, mojave:        "5b01e7e6bb639b68a33a3087db8cb10c476e2c8aa7957f20a18f214b70580979"
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
