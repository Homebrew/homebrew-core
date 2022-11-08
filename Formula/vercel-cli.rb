require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.15.tgz"
  sha256 "ccc3403e06896aee423797904fd6ab64b467c1d3a532ac1b21bc7ba7313ed782"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d90ee5891be7632cdd844de40ac98859c985b59f08add2b0922f0b78b6777d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d90ee5891be7632cdd844de40ac98859c985b59f08add2b0922f0b78b6777d0"
    sha256 cellar: :any_skip_relocation, monterey:       "7d1e9fac09897fdc2c3a7dccfdc7327128d034247465bcae74cee8b0de6f06e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d1e9fac09897fdc2c3a7dccfdc7327128d034247465bcae74cee8b0de6f06e2"
    sha256 cellar: :any_skip_relocation, catalina:       "7d1e9fac09897fdc2c3a7dccfdc7327128d034247465bcae74cee8b0de6f06e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af712cae49a5370a4c665f2d9f770bcd80d4c28072fdd4011c9ca0adfc73e240"
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
