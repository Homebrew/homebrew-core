class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.34.2.tgz"
  sha256 "b05e4cf54c6884fe8707cd87d7eaca08c4b6eafe12604202dbd52b44ae012342"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc9a3ab0d9d54d1c3fd5efd4eafbcdc21985de7277e110bc3fcccff92c6a6299"
    sha256 cellar: :any,                 arm64_sequoia: "008ad85501cb5097da73533362e140a0b4d6234d59d44975dcb87d9c4c46f51a"
    sha256 cellar: :any,                 arm64_sonoma:  "008ad85501cb5097da73533362e140a0b4d6234d59d44975dcb87d9c4c46f51a"
    sha256 cellar: :any,                 sonoma:        "d7adbb02d5e7bec21bb15da326cbb8593f58def87a4cab636c8b4a6a69b57295"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32e21f120b6b5afeceec209c3c2d09ea47e43c1bb0f22313538c75604e805eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef196eb11d47ef841e1442949a4d2ebeab153dc32646e91df98c59010660e676"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
