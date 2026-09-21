class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.23.2.tgz"
  sha256 "050213ead68f8ca8ff643e134407d52850a452098b3d95ac140e05141bcdabd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "fae97da845459717b8e73549afc6e9ceb5b9da4248ac7adf457a061bb557446a"
    sha256 cellar: :any,                 arm64_tahoe:       "fae97da845459717b8e73549afc6e9ceb5b9da4248ac7adf457a061bb557446a"
    sha256 cellar: :any,                 arm64_sequoia:     "fae97da845459717b8e73549afc6e9ceb5b9da4248ac7adf457a061bb557446a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8984d1e1bf47df7c69030abe4a05a4aaa281957ff20d7efd0006063fff01b25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "865ae869e890bc008b4a4668763dfb31bf34e22da30993c9d535d7f29cb90f99"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
