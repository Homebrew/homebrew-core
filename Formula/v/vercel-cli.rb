class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.6.1.tgz"
  sha256 "967a7339cbbfd5a465647c70d0de157949a7ad232f51065ff5cfffad260874eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60026c22a87c0479509205793b8e1dd37ef500dd18f969f09d063b7ef23d3150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60026c22a87c0479509205793b8e1dd37ef500dd18f969f09d063b7ef23d3150"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60026c22a87c0479509205793b8e1dd37ef500dd18f969f09d063b7ef23d3150"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce550184aa5848a1a424cd3fc212ee2d2013fcfb2ef05f6d5ad2b96d739ef25e"
    sha256 cellar: :any_skip_relocation, ventura:       "ce550184aa5848a1a424cd3fc212ee2d2013fcfb2ef05f6d5ad2b96d739ef25e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c72b14d2d56f17adeecc48729779b5ccd5eeee05dd0adb596d9c14a8a151ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f15ba65cde5807568c98ed57fe6f97bbdc337600153a474c074fcee6339bad0a"
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
