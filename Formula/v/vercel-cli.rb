require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.3.1.tgz"
  sha256 "b4184fa83092356bd31322edceb93b236df0b53bcded9e11b2540ae2e7046258"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6acd47146d3332e8e7cf52ec00c62c6950a4bdd49545e6cc83cb61d44cd31c65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6acd47146d3332e8e7cf52ec00c62c6950a4bdd49545e6cc83cb61d44cd31c65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6acd47146d3332e8e7cf52ec00c62c6950a4bdd49545e6cc83cb61d44cd31c65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6acd47146d3332e8e7cf52ec00c62c6950a4bdd49545e6cc83cb61d44cd31c65"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b930b93927ca3b085988e004f2c6b6b3a8dd48d8e7b7984f0d138c2fd55eae1"
    sha256 cellar: :any_skip_relocation, ventura:        "8b930b93927ca3b085988e004f2c6b6b3a8dd48d8e7b7984f0d138c2fd55eae1"
    sha256 cellar: :any_skip_relocation, monterey:       "8b930b93927ca3b085988e004f2c6b6b3a8dd48d8e7b7984f0d138c2fd55eae1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b930b93927ca3b085988e004f2c6b6b3a8dd48d8e7b7984f0d138c2fd55eae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f3d3f1d1ede6935b4f4fa336351835a90f179af386b0eb0cac3b569d74b1827"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
