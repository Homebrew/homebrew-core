class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.7.0.tgz"
  sha256 "8b468fb8453a37e6e1cdce201026ecce349839f0fc376dd5f4b3e9e29008bb3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7cf4e4967f85a30529c9dc7a9eb0d0e9f03030873c568b60260dd1f25e8d6ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7cf4e4967f85a30529c9dc7a9eb0d0e9f03030873c568b60260dd1f25e8d6ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7cf4e4967f85a30529c9dc7a9eb0d0e9f03030873c568b60260dd1f25e8d6ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "26d126901bd43c296cd95036fb612d3bcc52b36d7f61f7962d6d01d2b87c5ae7"
    sha256 cellar: :any_skip_relocation, ventura:       "26d126901bd43c296cd95036fb612d3bcc52b36d7f61f7962d6d01d2b87c5ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0c1b4fe640d7c332eb3b797f380f5b66adef25052fa1b55b96baf2854d1ee12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b23dfb833c8b822667dd5d61dcaf8c6cde5b3ef45fc419a274144591060451e"
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
