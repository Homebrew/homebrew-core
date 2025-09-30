class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.1.6.tgz"
  sha256 "3d956be3a8f5bac1df20a658121179eec89dd2ecdc734ed53b2d788e07f89a18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fdec4e4a8b6336eeec2322920c348698f3c80bf2968858a01ffb3efe2245d1e5"
    sha256 cellar: :any,                 arm64_sequoia: "37a9aa328ed402f472a9ce91fadc36641946ff5ac626b5a020b03d46fb3ab22b"
    sha256 cellar: :any,                 arm64_sonoma:  "37a9aa328ed402f472a9ce91fadc36641946ff5ac626b5a020b03d46fb3ab22b"
    sha256 cellar: :any,                 sonoma:        "c2b8833e155f29b41d19f05ebec270b53f234e148c1e03fa55ffa741a6127fed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7ea61987f23f8695c61675265dab7ece934f721f2980a35edab84cb4c33e170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cc561129f242dfd7f1a3076f4a0f7a94ad17173d7fc5402326fb45c86e5341e"
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
