require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.15.tgz"
  sha256 "ccc3403e06896aee423797904fd6ab64b467c1d3a532ac1b21bc7ba7313ed782"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a02e51566fa61ada7868de4802ad29026fc1b506066bab88db38e35740169333"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a02e51566fa61ada7868de4802ad29026fc1b506066bab88db38e35740169333"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a02e51566fa61ada7868de4802ad29026fc1b506066bab88db38e35740169333"
    sha256 cellar: :any_skip_relocation, monterey:       "b972ff95f2bb41f6600e7b8c5445e278248e62235efb229fd0e5662e79e0b003"
    sha256 cellar: :any_skip_relocation, big_sur:        "b972ff95f2bb41f6600e7b8c5445e278248e62235efb229fd0e5662e79e0b003"
    sha256 cellar: :any_skip_relocation, catalina:       "b972ff95f2bb41f6600e7b8c5445e278248e62235efb229fd0e5662e79e0b003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3daba50f75aeb39b3b1b4ef37176505ab61822a4575a32edf31a2599356948"
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
