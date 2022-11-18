require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.5.5.tgz"
  sha256 "52a13693cc8c4fc7eceeac7b1177063752e77dc68e3ff725c6fe85a103412244"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f94efee60529c0d9e05dcf33ea907de12a53d0aae6a9e43b3d87a85ac34e5b27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f94efee60529c0d9e05dcf33ea907de12a53d0aae6a9e43b3d87a85ac34e5b27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f94efee60529c0d9e05dcf33ea907de12a53d0aae6a9e43b3d87a85ac34e5b27"
    sha256 cellar: :any_skip_relocation, ventura:        "f62872204b1bdcc8de410393527289882411e1bc24d6c34bc38b62f16ec8afb2"
    sha256 cellar: :any_skip_relocation, monterey:       "f62872204b1bdcc8de410393527289882411e1bc24d6c34bc38b62f16ec8afb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f62872204b1bdcc8de410393527289882411e1bc24d6c34bc38b62f16ec8afb2"
    sha256 cellar: :any_skip_relocation, catalina:       "f62872204b1bdcc8de410393527289882411e1bc24d6c34bc38b62f16ec8afb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca8831913d8d27a908754f69f7b7f4bd2b6b19ceda117e551d75c95402bfc1b"
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
