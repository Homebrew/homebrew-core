class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.1.3.tgz"
  sha256 "6b2435c8d9ef82adaf45d9751c985a6bb9f06416dfb509dd2ac418a1bc6a053b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0c9d2d4f9ef1c8f52dc5f2d6816280307307e42f3500071c281c204e24006d8"
    sha256 cellar: :any,                 arm64_sequoia: "5c39365899b31789d84bc3e0a834274022f3ea1ec566c5c7b64be8c712a9e72d"
    sha256 cellar: :any,                 arm64_sonoma:  "5c39365899b31789d84bc3e0a834274022f3ea1ec566c5c7b64be8c712a9e72d"
    sha256 cellar: :any,                 sonoma:        "3ae9bc1677d99aaf0478a724bdfb7e051b63c13b8f7757a3ba97bec94c3f0abd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5e3fedfe62e04e905c0deed728103a6e4231e11a8590b857d2ad9e2aea4fd04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a564bb305031c75ed3b8644277b8c407cfb8519102addfedab51aaa98cf9d3"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
