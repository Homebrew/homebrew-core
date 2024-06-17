require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.7.tgz"
  sha256 "ea22f2d890fc7539a7a7dd7e9a2f666c925a658d5847e25f8925e5bacf9db4da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96906644a12a712421894a68d2b4409ab4b223dcf21aeb3590ca0f87461560bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96906644a12a712421894a68d2b4409ab4b223dcf21aeb3590ca0f87461560bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96906644a12a712421894a68d2b4409ab4b223dcf21aeb3590ca0f87461560bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d3d0e982164fa44ea8388b9acbb36a5d7fe30f75b40e4ee0352c571a6738cdd"
    sha256 cellar: :any_skip_relocation, ventura:        "1d3d0e982164fa44ea8388b9acbb36a5d7fe30f75b40e4ee0352c571a6738cdd"
    sha256 cellar: :any_skip_relocation, monterey:       "1d3d0e982164fa44ea8388b9acbb36a5d7fe30f75b40e4ee0352c571a6738cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a730d161aaae18c1df59917b7db506927261cb18e861f88064e8c30f2e14676"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
