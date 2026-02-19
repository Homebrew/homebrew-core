class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.19.1.tgz"
  sha256 "b16c9dfdf14d611246935f554055983638f089773617a32c0ebd9fc3c20d1022"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "119062aabc8d7c7f5e54723c9048d66a2b99c6e06fddeaafa09e0f403d6f87b4"
    sha256 cellar: :any,                 arm64_sequoia: "7396a05a27dedb9e8c36e79b050da4d5aa109a4ce35d8dba332365bb22bed808"
    sha256 cellar: :any,                 arm64_sonoma:  "7396a05a27dedb9e8c36e79b050da4d5aa109a4ce35d8dba332365bb22bed808"
    sha256 cellar: :any,                 sonoma:        "b7b8da08c1a3c8c4e200dcb72a437fc775eb755af1561398673cc58eaab34b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe13addfe222c5b175d10a8273e4b44c792d682f7161c13653b6e6bbb1631d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b064395be58c048402233325f22361e2ddc5627e3a2e5e0c0dce2471a5a64fb9"
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
