class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.0.tgz"
  sha256 "4f1054bcc44189549ac9aef7ebebd104240b486ab00498d99179c63072a776ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78b0b70863e5553f5375553486fd1931aa2db84f48d772782ad2eda1120ae994"
    sha256 cellar: :any,                 arm64_sequoia: "fe8d738fc4bb6ea7eae42c4a59607ababe4b3644b76b9934257b8e9e8ffbe99a"
    sha256 cellar: :any,                 arm64_sonoma:  "fe8d738fc4bb6ea7eae42c4a59607ababe4b3644b76b9934257b8e9e8ffbe99a"
    sha256 cellar: :any,                 sonoma:        "f40a4e4ab59769da2eb01101747725121999a64c2fec0512f990b982909a04ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dab9b0fdf0a3de84dda84767d5fa1985d09ada1c03f69599ccde37594c3204d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33333418cae57a582bb975c840e6db525508637eef733a219adc1636fdd36322"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
