class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.0.4.tgz"
  sha256 "762d4844facc2c2c5f4a712f6c8764496a0302e6134b59c0d77e814e7faf7edd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b30573e433cc47cc53e7e3f5f996949337c16ea5ce08e0e45375e6db4c210d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b30573e433cc47cc53e7e3f5f996949337c16ea5ce08e0e45375e6db4c210d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b30573e433cc47cc53e7e3f5f996949337c16ea5ce08e0e45375e6db4c210d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5074e84572bf43e1dba65806ef262ba594ca7855370804c377b51bdadbf02389"
    sha256 cellar: :any_skip_relocation, ventura:       "5074e84572bf43e1dba65806ef262ba594ca7855370804c377b51bdadbf02389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e8e37351df2417172f59247dccb5f2a600043baca4020fe3a710a3b67ebe3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d605214072794216ecbc9e59f1c5b0d9691467b7dd06e64b0dd0f19c96bf0a7"
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
