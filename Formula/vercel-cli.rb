require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.14.1.tgz"
  sha256 "2065027437a6e0a5b8cc8429f514673f0b2b4d70eefa4fc3120bcf64d2074f63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fbbb4fdf73e2c0e2b6e3d19bae0c026ea1d5dcf6e1b8f968bbb0882f5bad5e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fbbb4fdf73e2c0e2b6e3d19bae0c026ea1d5dcf6e1b8f968bbb0882f5bad5e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fbbb4fdf73e2c0e2b6e3d19bae0c026ea1d5dcf6e1b8f968bbb0882f5bad5e5"
    sha256 cellar: :any_skip_relocation, ventura:        "48fba7aa89bd80bbb046022aa5c5069d3eb74ee3712b9de5720b457f95d38a08"
    sha256 cellar: :any_skip_relocation, monterey:       "48fba7aa89bd80bbb046022aa5c5069d3eb74ee3712b9de5720b457f95d38a08"
    sha256 cellar: :any_skip_relocation, big_sur:        "48fba7aa89bd80bbb046022aa5c5069d3eb74ee3712b9de5720b457f95d38a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a13a618912f0aaabb08c5604cf5971128b312988a10200b1be3242ca13cb148"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    dist_dir = libexec/"lib/node_modules/vercel/dist"
    rm_rf dist_dir/"term-size"

    if OS.mac?
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(dist_dir), dist_dir
    end
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
