class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.15.0.tgz"
  sha256 "c85beadca182b2ef251a0d4b038667ae52df9da2db48b6534ef974ccffa473e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7fee3d512ab22689943c6bb20687c9ce4d2b46e50dd388ec8cac0b9a89b26d1"
    sha256 cellar: :any,                 arm64_sequoia: "4426136f5710ad86a399dfbb72622a0e4d7ce7edc6648cc4ad4e29a863e3c5dd"
    sha256 cellar: :any,                 arm64_sonoma:  "4426136f5710ad86a399dfbb72622a0e4d7ce7edc6648cc4ad4e29a863e3c5dd"
    sha256 cellar: :any,                 sonoma:        "e4a8c1a509e8d58b8a675095af473688e518a5ce8589712cfad4b747653a5277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6218b99014c67119f9c4b72ab00ce27452a4b83118e3c736654be8bea6454c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99305b5621dc275d665c6c4d23d956964f1ce731d069b375ed57a9dfd5baffd9"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               "'brew upgrade vercel-cli'"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
