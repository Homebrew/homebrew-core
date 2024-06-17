require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.3.0.tgz"
  sha256 "4fab4f7b16305d0082b1bc28dde23e5af4344589b16f3a278904807bd620bebd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73a3fead4541ac543c2b4c9201e767dc8742ee6aced10ba274bbfad0e83de8d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62ad1b55475d7b8fba3e449cacafabe70ea5b9c569a41398938de2cfa709cdc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb4309aa20d37a0bfacbe6e043037018f60beaa67577b7f5549239d944a4fab7"
    sha256 cellar: :any_skip_relocation, sonoma:         "37bd0f8aba971dd89115af130f182e0ec395fa053e3f3916e0e5e0bd7d20c05a"
    sha256 cellar: :any_skip_relocation, ventura:        "720d7b6d07e05d3adeda0ceab34fd326bbb0a047f65e91ca6de476f1e7b911ce"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1c8156ce512a1180d41d3f760fdc19638deafc8623320667049d086dd229f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc596c930b3edf5e380d14a0188ea901bc6de268e0452e6a387861e0be52e2f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/release-it -v")
    (testpath/"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(/Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)/m,
      shell_output("#{bin}/release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath/"package.json").read
  end
end
