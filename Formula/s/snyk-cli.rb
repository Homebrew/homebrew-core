class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1293.1.tgz"
  sha256 "52d6e02fe543283e39691c5ee59e09f7839bd0b00a7e02376c45e7019f210d79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fed288ab9c2b3f73abc69e7d78c1fc8ad06573e0d0f6323720dbd881d0254e5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fed288ab9c2b3f73abc69e7d78c1fc8ad06573e0d0f6323720dbd881d0254e5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fed288ab9c2b3f73abc69e7d78c1fc8ad06573e0d0f6323720dbd881d0254e5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fed288ab9c2b3f73abc69e7d78c1fc8ad06573e0d0f6323720dbd881d0254e5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed7c8f040763983cb9e6387c7776f53e0edbb85c4bd69d5fe8297b0ab1d3794c"
    sha256 cellar: :any_skip_relocation, ventura:        "ed7c8f040763983cb9e6387c7776f53e0edbb85c4bd69d5fe8297b0ab1d3794c"
    sha256 cellar: :any_skip_relocation, monterey:       "ed7c8f040763983cb9e6387c7776f53e0edbb85c4bd69d5fe8297b0ab1d3794c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d2ff5fcd8ea860fb6a0019109f3cdc24f4a6bc7cfe1f43b48ddacfc24c60606"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end
