require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.2.4.tgz"
  sha256 "01558578ff13e2735107c2ecd4782c09585fbd79ab12fef293009010d23ab84e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a17d2fdf4da9073e0cd258bbbc5491378bca3f6195067fa3399e23b87119cb83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a17d2fdf4da9073e0cd258bbbc5491378bca3f6195067fa3399e23b87119cb83"
    sha256 cellar: :any_skip_relocation, monterey:       "22f5cdfbd3bf1647127e07b4788c24df05e112023a75cb371c6595165f702dd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b08dd22f2f7b9d1bef6e029f8d9dc8cab07a63d0a5e7ae4492a2ee7b9977a1e4"
    sha256 cellar: :any_skip_relocation, catalina:       "b08dd22f2f7b9d1bef6e029f8d9dc8cab07a63d0a5e7ae4492a2ee7b9977a1e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f387b94d09366ed97395729bc54f049618bc6181220706ebc0118ba00de2aae3"
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
