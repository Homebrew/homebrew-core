require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.6.tgz"
  sha256 "dd4be3a093ec4e70afab5509792e2337fbe76031f16ade633e50bf32a5ad2d4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b745fe4ca59c85a7424f81d75bf5287d0b7607da897d14feb4a1ad9a2a945d50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b745fe4ca59c85a7424f81d75bf5287d0b7607da897d14feb4a1ad9a2a945d50"
    sha256 cellar: :any_skip_relocation, monterey:       "fb331a586c3ca329fdd543c3c4ffa24df469eb9dbdaa0f78acc53a02bbcde0e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b255d0d1f34d10bac4f9bf313c864e4f3a0f49bdd8e4bb6eba78ed03dc21cbb7"
    sha256 cellar: :any_skip_relocation, catalina:       "b255d0d1f34d10bac4f9bf313c864e4f3a0f49bdd8e4bb6eba78ed03dc21cbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de9ea16297ad5d51a5ed79738452377ee2bd8df6d9e5693c1b7e0f6c3372684"
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
