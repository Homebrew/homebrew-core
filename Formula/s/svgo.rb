class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "bf79f18acd85764bd12ed7335f2d8fdc7d11760e7c4ed8bd0dc39f1272825671"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfb22cbbfc2556dfb800646cb44dc25d7558d11fa47d4996e37e2877cb99b60c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfb22cbbfc2556dfb800646cb44dc25d7558d11fa47d4996e37e2877cb99b60c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfb22cbbfc2556dfb800646cb44dc25d7558d11fa47d4996e37e2877cb99b60c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfb22cbbfc2556dfb800646cb44dc25d7558d11fa47d4996e37e2877cb99b60c"
    sha256 cellar: :any_skip_relocation, ventura:        "dfb22cbbfc2556dfb800646cb44dc25d7558d11fa47d4996e37e2877cb99b60c"
    sha256 cellar: :any_skip_relocation, monterey:       "dfb22cbbfc2556dfb800646cb44dc25d7558d11fa47d4996e37e2877cb99b60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9147dd29c841446a543d3220fc655c2385b2ecdd6911e6586a61658917faa55"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
