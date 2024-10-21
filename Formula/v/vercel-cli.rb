class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.11.0.tgz"
  sha256 "1fa86e6fb7e945967fc990f1b9593422969f25b15b832eba6b0a85816f925629"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b64db18ac57d287aef9dd21fec50ffbccd37c9fbbb7e330791163ca63fe15a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b64db18ac57d287aef9dd21fec50ffbccd37c9fbbb7e330791163ca63fe15a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b64db18ac57d287aef9dd21fec50ffbccd37c9fbbb7e330791163ca63fe15a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "01c80f359d15010cc62f5057d6d346094355d51627f6ccb797d79ea9f3628082"
    sha256 cellar: :any_skip_relocation, ventura:       "01c80f359d15010cc62f5057d6d346094355d51627f6ccb797d79ea9f3628082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a869ae2d60b9dc174fc7f8abafbbd566710b886eeb10b68ec01926641823e3d"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
