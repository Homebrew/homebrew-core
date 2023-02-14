require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.15.4.tgz"
  sha256 "486ebbd3a3fcd7c821150c1300638953d6c55cc5495b2ba5da4547ef77fd3798"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b32ff0ec82608f613d3c3cb0108f27f584500b81d7a86663a2252467020e4e90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6a9ccf8a636ee9d884c5f636fcddbb4149231cc1339d8cfe94e3b0c8b599974"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06a03c92bc1a7719f6c24afe8eb16786b25d72e9681243dac38f9f8689dfd8fe"
    sha256 cellar: :any_skip_relocation, ventura:        "f075679f991e1b2b7b546828713443b2390f9813480e8d5361d2b633c75c1187"
    sha256 cellar: :any_skip_relocation, monterey:       "8c81c6e57a074b6f29b8ae6722b74f4e756093f742c8301be943dc70029e593b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5601c4f564c0f567db366b4a679108f019e68d8f3ba382e62f585efec7c113c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677ae5f933a25677df15b911b6452d069c6b34dc95570966c67645524773cca6"
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
