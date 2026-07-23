class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.5.0.tgz"
  sha256 "b48ef9f10b21643984ac9f85a92fab6554a78d04e3ccbd95cc7472b43c3bea11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7113946eeeb7f3874cd17ce50a43bb167b82328dfedaeec7e2cd8e311a4d6630"
    sha256 cellar: :any,                 arm64_sequoia: "7113946eeeb7f3874cd17ce50a43bb167b82328dfedaeec7e2cd8e311a4d6630"
    sha256 cellar: :any,                 arm64_sonoma:  "7113946eeeb7f3874cd17ce50a43bb167b82328dfedaeec7e2cd8e311a4d6630"
    sha256 cellar: :any,                 sonoma:        "c9a3f6b554a5dc713b5995cb443329ed8d95a2d0b66c30aabe46fe331a5e24ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d695e41f5b9d21cd38a76c9811efa595f3b876caeaea41e50aa955dc483e06d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "719027f35de81abea5f3f80378569fff549970a690c3708c2f07fe296257752d"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
