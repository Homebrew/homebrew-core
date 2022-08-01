require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.3.3.tgz"
  sha256 "dfffa6cf8526738cf4f34137f9ef4a3e76819141730541a353b4c8ab6445db39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b4c73ee02d6ab774750f31dd1934315c8bec2cd89f904f32783345527094556"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b4c73ee02d6ab774750f31dd1934315c8bec2cd89f904f32783345527094556"
    sha256 cellar: :any_skip_relocation, monterey:       "5aa10b807a30181d04ddc6f00c50c4ba4f58ee19388f8b472b4b7c99d875515c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e9969458a9500ffec08a58a6ceece2ddfb4a53388380be1331fed2d45eb7ed"
    sha256 cellar: :any_skip_relocation, catalina:       "f3e9969458a9500ffec08a58a6ceece2ddfb4a53388380be1331fed2d45eb7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b311337e4ebb8c67e00d006bcd9d9a708ab2c219ad93ef676378a21ad2d0af0"
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
