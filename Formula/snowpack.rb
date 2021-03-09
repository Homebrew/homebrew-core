require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.0.13.tgz"
  sha256 "35cf6805e4253f22a79a1496f529f88c39a441d798b0e691c53cd94e1413516f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4148264a15951547102b58c903a2f34709b79643d4d4991789aac3d9d8d65219"
    sha256 cellar: :any_skip_relocation, big_sur:       "b99f05b87d6539b8312e7cf983e2fc7027f5372649b91907c187b63d7deaa323"
    sha256 cellar: :any_skip_relocation, catalina:      "e45083a22c9a458ae356f158199c73ad5a7210f10d5a6b4d0e369f6d2d2d2b3a"
    sha256 cellar: :any_skip_relocation, mojave:        "8bec25b62e92fc68ba75c975df570fc6fcaff05684c2a848c6252487bd51d9be"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"snowpack", "init"
    assert_predicate testpath/"snowpack.config.js", :exist?

    inreplace testpath/"snowpack.config.js",
      "  packageOptions: {\n    /* ... */\n  },",
      "  packageOptions: {\n    source: \"remote\"\n  },"
    system bin/"snowpack", "add", "react"
    deps_contents = File.read testpath/"snowpack.deps.json"
    assert_match(/\s*"dependencies":\s*{\s*"react": ".*"\s*}/, deps_contents)

    system bin/"snowpack", "build"
    assert_predicate testpath/"build/_snowpack/env.js", :exist?
  end
end
