require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.12.6.tgz"
  sha256 "21c0c2316f795506e0750b28f05505ec919606ca2459ab8b6abf5e49dfdb15ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f08a923ef185be35f57db30ee3b477e11a3967a84aca1403f1c4a4cdb1a3b15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f08a923ef185be35f57db30ee3b477e11a3967a84aca1403f1c4a4cdb1a3b15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f08a923ef185be35f57db30ee3b477e11a3967a84aca1403f1c4a4cdb1a3b15"
    sha256 cellar: :any_skip_relocation, ventura:        "ef44f726c2617297bda346a764eea59d79ce60feb962029d94bf637f3cce6a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "ef44f726c2617297bda346a764eea59d79ce60feb962029d94bf637f3cce6a7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef44f726c2617297bda346a764eea59d79ce60feb962029d94bf637f3cce6a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5ba6cfabe920fabb0cb74411148c7937bd6a727f4adc6d462251de89474f38"
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
