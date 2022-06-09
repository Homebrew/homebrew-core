require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-25.1.0.tgz"
  sha256 "6049084e2ceb9bc57cf58a187a870cabb3606e0d1c75fa79483dbe5e5c3f1228"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ae66e0b0afbc3d86d6dac9533340cedf94cea6eb9acc215a1c9240dbe6c5450"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ae66e0b0afbc3d86d6dac9533340cedf94cea6eb9acc215a1c9240dbe6c5450"
    sha256 cellar: :any_skip_relocation, monterey:       "64d170effbd4f79299f526a15131126242b1e9342a74c83d6e9d0f8e4d8c8c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9e6d6f5eb10f16aabb2cc4218991e864ea40a933e4510655aa38a0a51879b81"
    sha256 cellar: :any_skip_relocation, catalina:       "a9e6d6f5eb10f16aabb2cc4218991e864ea40a933e4510655aa38a0a51879b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33c1e28b946647532732665b6600161389381076a496ed36f0d304d2725971c0"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
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
