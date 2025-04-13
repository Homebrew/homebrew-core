class Yo < Formula
  desc "CLI tool for running Yeoman generators"
  homepage "https://yeoman.io"
  url "https://registry.npmjs.org/yo/-/yo-5.1.0.tgz"
  sha256 "b3b2abe646c47d8e60b93394ed219779dce26347c59d8ba337a62ea4226e1ec5"
  license "BSD-2-Clause"
  head "https://github.com/yeoman/yo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87fa6dcf1b186cf50436be4488b6bf312d55a967b0593137c1d99a8e95e5060c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87fa6dcf1b186cf50436be4488b6bf312d55a967b0593137c1d99a8e95e5060c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87fa6dcf1b186cf50436be4488b6bf312d55a967b0593137c1d99a8e95e5060c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ccc92540b6f284e3c3456c61ad339722bf13dba744f25f41847930812e54f0"
    sha256 cellar: :any_skip_relocation, ventura:       "a642a8c54ab92195e9149ac1c73598a8557cf6f28c4fde6bcdbfccc6e236367d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92925df2a2cd8a7c1063561119fbfd75a7df95e0dc766ee1fee0f0c3300b41ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d627be31558a619bfff889f3fa6421c64178f62af9e8dedcda5b18940e90ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
    assert_match "Everything looks all right!", shell_output("#{bin}/yo doctor")
  end
end
