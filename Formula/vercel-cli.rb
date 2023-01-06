require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.10.3.tgz"
  sha256 "a9cb30d43712d95f8f264a631bd7b01039371ab6d2a28e686e471bf833ec7b5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ffe76d7c505f6f17f88d21fa63188fb8cd5596932477f73b09f57016a045ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ffe76d7c505f6f17f88d21fa63188fb8cd5596932477f73b09f57016a045ca9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ffe76d7c505f6f17f88d21fa63188fb8cd5596932477f73b09f57016a045ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "ea4e8d9231f6f69243f9874165bf6d28d2f9979f894c66677490ce0eb0b19226"
    sha256 cellar: :any_skip_relocation, monterey:       "ea4e8d9231f6f69243f9874165bf6d28d2f9979f894c66677490ce0eb0b19226"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea4e8d9231f6f69243f9874165bf6d28d2f9979f894c66677490ce0eb0b19226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc86aee68200d8fdd7ff14d91073a443e671018719e9912b48e7d59fb2f73cd9"
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
