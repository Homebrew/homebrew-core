require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.8.8.tgz"
  sha256 "0cf99f86955b29c3e40332131e488ff38f64045ef23ba649d0a20c2a7cd2d29e"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "a58108194a509b22ed1f173f6bd1d5debd8a877d5cd536f280d06df5d6f906c8"
    sha256                               arm64_big_sur:  "424c198450962b4be8cf4314d570ff7e8febc23308b22430a47b8aaf0d4f3531"
    sha256                               monterey:       "91948373b19aad386bab35fb3cd536b7973c57a4ce0e363c2a035617ed02b1d9"
    sha256                               big_sur:        "fb13d64f32a7d9bdc58cf4dfd6776bf1254b09029b2778c6b6ae8aa1f3af5897"
    sha256                               catalina:       "abed65f5debef77a9380822f5612b17933df211375766e800fb9e481f2829178"
    sha256                               mojave:         "76e0af8a4e5f7fbc2d2095e8c6524c80a8e03ac2c9f9cbc2b8b319fff3dd7056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78baacecc857f50f7a6fbe7643c4edad620c4e2c09a0f31e336fcfa52f0576e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
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
