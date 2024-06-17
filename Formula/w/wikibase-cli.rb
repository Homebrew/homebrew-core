require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.0.3.tgz"
  sha256 "27818f6434900c9d4437ef2c4d360164b56d04179a9e95ae6a299252aed2cb5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eaabbb26669459852c220b8dbd069373ed512f33bb1b38a5301fcd1adc4608c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "babbe61d4a9797a1e2b5b3b0e7f91de0bef1eb8262759b95b392876cded36fe0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b3ea161bcf2bb705ed1c68676a6c6a76422fca56c9537d9dae6904234807b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac8474e59d1faaa52e0a81d5d60ed93a575c21a092703fbf5a6824c38656e962"
    sha256 cellar: :any_skip_relocation, ventura:        "ec756af65f59ba009600435761867a717b1df6905d1ccb00940aeba3332f88a0"
    sha256 cellar: :any_skip_relocation, monterey:       "e0dc8ea1f6735c1df6dfccc72a5ab6d28bd5b02840acdc659ee8a179643e126a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5563fa4e26fcf0dd8a19858d1371c70e6405f8aec337f411b5681cff84aec467"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip
  end
end
