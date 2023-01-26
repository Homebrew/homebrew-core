require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.13.2.tgz"
  sha256 "ccd60062623e99b436d9b85d608e1c48cbed63caa90ab2754f14d39af3285066"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b657ebbae4e734395cc5c0af9eae66497882f2c50f912a643f2cd475755a9be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b657ebbae4e734395cc5c0af9eae66497882f2c50f912a643f2cd475755a9be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b657ebbae4e734395cc5c0af9eae66497882f2c50f912a643f2cd475755a9be"
    sha256 cellar: :any_skip_relocation, ventura:        "5371a4264891d85b9c197c32fdd061bbc29d84331eb8c0e275588774859ac9b6"
    sha256 cellar: :any_skip_relocation, monterey:       "5371a4264891d85b9c197c32fdd061bbc29d84331eb8c0e275588774859ac9b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5371a4264891d85b9c197c32fdd061bbc29d84331eb8c0e275588774859ac9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83149bfe9af11b97a4ff40b9c1abef234df3f12a07403884294503a740bf9a4a"
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
