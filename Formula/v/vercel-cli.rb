class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.35.0.tgz"
  sha256 "5147df429cb5af31613f80bb3d998815cb27d0969698846415136619bfce599f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6554a3013ea91d732b4c4a1ac843aa808715ac563723e767f2b1d8b7e75d3151"
    sha256 cellar: :any,                 arm64_sequoia: "c0639e4acbeefbd25a760538c3e9c8ce7412831ad8a5943522aca086de1ba1b3"
    sha256 cellar: :any,                 arm64_sonoma:  "c0639e4acbeefbd25a760538c3e9c8ce7412831ad8a5943522aca086de1ba1b3"
    sha256 cellar: :any,                 sonoma:        "71c5d9e74aaedf32ddc965a3c82e46ba4f20b55aa6dda1d5f4f0d1b497a494fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47440b13ea1f13b259500b88cff9186bd60da39ff8a8d5552d47326e16584ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfc70c9784be615128965350a6cd076d313e471199cbc14b70705f25ad61abc7"
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
