class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.0.2.tgz"
  sha256 "8c0fef1336c4d4adb132f0919c977a7e28a8b460a24ce88c249acb34217e787e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08492003e7033afa239b2f6676d5b4bb8e98f4ad5789f42cffee19760053f146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08492003e7033afa239b2f6676d5b4bb8e98f4ad5789f42cffee19760053f146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08492003e7033afa239b2f6676d5b4bb8e98f4ad5789f42cffee19760053f146"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac59cb633a19b9296c126ba9f35db9e076b2a06ab0350006ad81bbca0eb859a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a8eadcda3c10bed6924a3b9ba4779b977e6115fceb77386e35379768581e493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db7786033857226e4e246cf971c085e539a8040553e2baa8b3f66dfb9776fcc9"
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
