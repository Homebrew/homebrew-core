class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.5.0.tgz"
  sha256 "d48e14637ef2892b5101cb5ef9c0ef4d6210d7f73842a0e9f432ae9a4a773414"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32a86c8a7c5246962a0094b86799b2d89725d99d68a7cd189ff68b783bc64a6f"
    sha256 cellar: :any,                 arm64_sequoia: "32a86c8a7c5246962a0094b86799b2d89725d99d68a7cd189ff68b783bc64a6f"
    sha256 cellar: :any,                 arm64_sonoma:  "32a86c8a7c5246962a0094b86799b2d89725d99d68a7cd189ff68b783bc64a6f"
    sha256 cellar: :any,                 sonoma:        "b59f1554f03c9255edfddd70efffd184c56fb7e495079f52a8213674206eebac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccb719c18e442631f98318f3b889933bc03e8ea9c57a04a4c0bbc82db05ceabe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bc872235090289d6f1d294b1b1707e2af1c47289ff5623abcf03618705a9f9"
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
