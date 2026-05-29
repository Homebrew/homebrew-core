class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.5.1.tgz"
  sha256 "dbfb525ba81826fa896f2bb51c3dadf7d5477c2068a83db280a0cc759024505e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb08885f150ca8a2a2224072479a6a542d632fccc8cc9e193451e24b34190abf"
    sha256 cellar: :any,                 arm64_sequoia: "5da8cbd930359e9db56be44320d6728e8a2b48e32f05d78d61c58fb780b7cbeb"
    sha256 cellar: :any,                 arm64_sonoma:  "5da8cbd930359e9db56be44320d6728e8a2b48e32f05d78d61c58fb780b7cbeb"
    sha256 cellar: :any,                 sonoma:        "da61aa6a2ae14fa5aa26facf76065d7d0ad1726a9bff5024f2217f4dac56cd4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cc64ea3e53cab1b9e4f384c5b3b45a8b01faba0fba0359633716421d9e8e6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1d2e6edbc239227cdda55cea6bc6e3b8eda340cbbb83fc07e3d52a98d0769d"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
