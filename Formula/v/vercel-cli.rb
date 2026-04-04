class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.39.0.tgz"
  sha256 "a9298ae69a5fd7fb27268c5269810055062a558b413069d11d10d29b438d302b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e76c2f143dbddd48c5c7f1e670801d7a15fe54d48fb3c67d216d00a2ece99a3"
    sha256 cellar: :any,                 arm64_sequoia: "56bb743b4036fcf1d75d6da07a90b4c6d146d7aca2755d9e945918d2565d9150"
    sha256 cellar: :any,                 arm64_sonoma:  "56bb743b4036fcf1d75d6da07a90b4c6d146d7aca2755d9e945918d2565d9150"
    sha256 cellar: :any,                 sonoma:        "4683c5863042bb90c41d2f23a85bdf4d76a815d4106d2716de56da08a90ddf31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aaee5a43e7aabd7fbc8ca35d4b3e4437767594ac85b203609a8154f5de2dba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a039f62bdd215f0b187336e37d60f13da56a2a5b347f4441bcbd87e4e7be17"
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
