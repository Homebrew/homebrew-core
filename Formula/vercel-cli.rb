require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.14.tgz"
  sha256 "8aa54c4a2f68d3f52faadcce8587848b0fc41ec89cf4aa6cc6cfdc1e394ff88e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51233e6261f1cb256e774eb59c6bc29819060379638ee738aff7323868ad6194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "431c32367c902c36166991714f1f44c59e00456f9f152c4cca0f116319bcd2f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "431c32367c902c36166991714f1f44c59e00456f9f152c4cca0f116319bcd2f3"
    sha256 cellar: :any_skip_relocation, monterey:       "5a4bbe6335a6156b205f8436464d6b0e4eb36d75884e798af9756ea34673d588"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ac2187bdb1a285a43ff05623b846011fcb2dd1e4a989204f033096cbee9b72c"
    sha256 cellar: :any_skip_relocation, catalina:       "1ac2187bdb1a285a43ff05623b846011fcb2dd1e4a989204f033096cbee9b72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ff9206710e3f262481d9e50c161b285a9b10738aacc6a6bc4ffe3ffcf96ad79"
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
