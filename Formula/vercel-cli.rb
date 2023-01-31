require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.14.1.tgz"
  sha256 "2065027437a6e0a5b8cc8429f514673f0b2b4d70eefa4fc3120bcf64d2074f63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "436bbb06270ac2d2ee85f275b0e3b8ee592631f75956c4762e5adfb870998341"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436bbb06270ac2d2ee85f275b0e3b8ee592631f75956c4762e5adfb870998341"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "436bbb06270ac2d2ee85f275b0e3b8ee592631f75956c4762e5adfb870998341"
    sha256 cellar: :any_skip_relocation, ventura:        "3929d69a33d8cfd842d877fa609126dc9e8599f423983fd057b6bdcccf562bcf"
    sha256 cellar: :any_skip_relocation, monterey:       "3929d69a33d8cfd842d877fa609126dc9e8599f423983fd057b6bdcccf562bcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3929d69a33d8cfd842d877fa609126dc9e8599f423983fd057b6bdcccf562bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f5203b768a2ae128765e9f60aecd6e7227f872cbef01dc593250fed39972ca"
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
