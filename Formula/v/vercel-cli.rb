class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-52.0.0.tgz"
  sha256 "aa2f79170d8dc4ac1505824f2e366d07bbcb324b22ae5f7be95e5833f0469864"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c362ca345a56588c2223f84dd232c93071db958344b5c3b35eb6a4d8230f0431"
    sha256 cellar: :any,                 arm64_sequoia: "d443ec35022fb7b6249c170236474ea724af20cece8da26292276ba35e84920e"
    sha256 cellar: :any,                 arm64_sonoma:  "d443ec35022fb7b6249c170236474ea724af20cece8da26292276ba35e84920e"
    sha256 cellar: :any,                 sonoma:        "93d8abf579c97cb2084d8614ae9aa57ace479c09b5d854e38a11c22e595b85c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55bb60a68a192f54fb273c12c6bf577b3de91526f1ddd7c8e73dfcbbac0a5de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "517687a7164366de9a8a88e453617bfc5d8dc82da7443f20a4e3b277b7218f9d"
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
