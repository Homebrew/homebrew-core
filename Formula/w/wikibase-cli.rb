require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-17.0.4.tgz"
  sha256 "db3d5a38a5501694c7c65f98d64ee6f102daf8a7ba83efa7edbf3737eb305331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e53f6934a0a16ad31fdc79bd89a4f3a89336232976e364f0c295aaf5782f574c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e53f6934a0a16ad31fdc79bd89a4f3a89336232976e364f0c295aaf5782f574c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e53f6934a0a16ad31fdc79bd89a4f3a89336232976e364f0c295aaf5782f574c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6668a447ea8b789d49dfd1d53c2f6ba4bad4d5fd323ac4b3d1e961cd622ee726"
    sha256 cellar: :any_skip_relocation, ventura:        "6668a447ea8b789d49dfd1d53c2f6ba4bad4d5fd323ac4b3d1e961cd622ee726"
    sha256 cellar: :any_skip_relocation, monterey:       "6668a447ea8b789d49dfd1d53c2f6ba4bad4d5fd323ac4b3d1e961cd622ee726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e53f6934a0a16ad31fdc79bd89a4f3a89336232976e364f0c295aaf5782f574c"
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
