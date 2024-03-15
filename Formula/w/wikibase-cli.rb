require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.0.0.tgz"
  sha256 "b4100d9f6ff5159f59d4a7d7925912ca2fbe0eac81fb5e8c07e3a62bca6322ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e405ac55f9588961116e78b25be987cdaa9728864911dab31333cbb1d9d0c97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e405ac55f9588961116e78b25be987cdaa9728864911dab31333cbb1d9d0c97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e405ac55f9588961116e78b25be987cdaa9728864911dab31333cbb1d9d0c97"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd22f3d07509458bda8b65883c96950616e367568a71e00c89c5f5670f7ffd77"
    sha256 cellar: :any_skip_relocation, ventura:        "bd22f3d07509458bda8b65883c96950616e367568a71e00c89c5f5670f7ffd77"
    sha256 cellar: :any_skip_relocation, monterey:       "bd22f3d07509458bda8b65883c96950616e367568a71e00c89c5f5670f7ffd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e405ac55f9588961116e78b25be987cdaa9728864911dab31333cbb1d9d0c97"
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
