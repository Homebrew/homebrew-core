require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.8.8.tgz"
  sha256 "0cf99f86955b29c3e40332131e488ff38f64045ef23ba649d0a20c2a7cd2d29e"
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
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    libexec.glob("lib/node_modules/snowpack/node_modules/{bufferutil,utf-8-validate}/prebuilds/*")
           .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
    # `rollup` < 2.38.3 uses x86_64-specific `fsevents`. Can remove when `rollup` is updated.
    (libexec/"lib/node_modules/snowpack/node_modules/rollup/node_modules/fsevents").rmtree if Hardware::CPU.arm?

    # Replace universal binaries with their native slices
    deuniversalize_machos
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
