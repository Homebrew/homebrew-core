require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.8.8.tgz"
  sha256 "0cf99f86955b29c3e40332131e488ff38f64045ef23ba649d0a20c2a7cd2d29e"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "c70bc6af65ffe1e7a64affd8f4746eec356ea5ab75099ffbe1ca9fc4990dc967"
    sha256                               arm64_monterey: "664c54d473633b9ed2c4054deba8b04c30b753f938183c0c6781174806643d74"
    sha256                               arm64_big_sur:  "4923f5146a642c4e2b697ddbcc37506c072897c0cbf34dc9242c150acfc3349a"
    sha256                               ventura:        "07fea8b685008cf30fd14b9fe940e3edcce911eddd477d29555fa5b129e780c1"
    sha256                               monterey:       "94762b004ce3f84d1ffa533a78ccf935478cd4a5fedc201cdb6f05bce180426d"
    sha256                               big_sur:        "f6b3e81c3969067b7c8d360b2844093632046d583dcef6a709b17821369c2f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd5deee0b0428290e67b488012e522e2570a77aa21f71db54e04f7c5d00ec68b"
  end

  deprecate! date: "2023-05-09", because: :deprecated_upstream

  depends_on "node@18"
  depends_on "python@3.10"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--python=python3.10"
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
    ENV.prepend_path "PATH", Formula["node@18"].bin
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
