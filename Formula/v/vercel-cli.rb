class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.41.0.tgz"
  sha256 "cb4bdd24a7db5aca40652fc89c633cedbc9cb16847f5904c06366b4b05a5edd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad1e14fadaa75af73190d8f78d635b10448ff08ef997dbc5b99026e18c5c5f1c"
    sha256 cellar: :any,                 arm64_sequoia: "9ad7772311149c0267f64cd8cd65e98b99819ab043f7710a97d34c569cc2f842"
    sha256 cellar: :any,                 arm64_sonoma:  "9ad7772311149c0267f64cd8cd65e98b99819ab043f7710a97d34c569cc2f842"
    sha256 cellar: :any,                 sonoma:        "5a74568ae8d01a3cfa10616e8293cd76762d5c571fa6246f062bf63501df493a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0a6f2c5de6f038bd5fa72f7a5c189eabd9e7c650f57d264227415de0e5bdb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f62281cfb1745977ff52756b941e5faae4ea4e14cad669aff23b9fbcd3a01a7"
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
