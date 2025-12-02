class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.12.0.tgz"
  sha256 "c4f8970f3ee73135c84034264dac56ea2e9da631f607ac02a514b726c5c34dd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f27157b641ef5b15fe617aa2ac4e0ad95ec292c4646cffc229b87485532faf7"
    sha256 cellar: :any,                 arm64_sequoia: "c1f5d7a4949030a83a922fa798e83a784a3f49efebf6607731deb0caefd29d6c"
    sha256 cellar: :any,                 arm64_sonoma:  "c1f5d7a4949030a83a922fa798e83a784a3f49efebf6607731deb0caefd29d6c"
    sha256 cellar: :any,                 sonoma:        "43976de069aecf41060bdfa590117616e01291da9e322ad50c974b3926d74268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13abc30c91db5c9c246e3f814a03e424c9a11e561c3d6f350725612844ffce9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b3b2fc15b852b856255c6e8e5d5c82d1e1f102ee4a795026811c5e70c574f5d"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
