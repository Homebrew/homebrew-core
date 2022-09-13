require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.2.5.tgz"
  sha256 "54690bb443f8e460f9ac2aeb1293d22f084004e0df62546e4ee9cb0276dd74c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d6680e60548d27ad6139d2e6bcc754d5f0f8f7c0d1883c73b90b7aabaaa7546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d6680e60548d27ad6139d2e6bcc754d5f0f8f7c0d1883c73b90b7aabaaa7546"
    sha256 cellar: :any_skip_relocation, monterey:       "c015cc3f4e37234737f68a766d6cf08935a96a416424eb1a7379fef429d0b91d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c584012f11ed25b4345aaad5419940be59435f01024971dfc3241d4a846603c8"
    sha256 cellar: :any_skip_relocation, catalina:       "c584012f11ed25b4345aaad5419940be59435f01024971dfc3241d4a846603c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dfce02d2825de1a2421c7441cb06ce7af839cffcb4c5dbc83d536d14c147f33"
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
