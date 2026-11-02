class Worldmonitor < Formula
  desc "Command-line client for the World Monitor global intelligence API"
  homepage "https://worldmonitor.app/docs/cli"
  url "https://registry.npmjs.org/worldmonitor/-/worldmonitor-0.2.2.tgz"
  sha256 "74d7b9b0e60c09deeb2b99b659bb6cea4ecab3c755a7fd73774c2fb379bf3899"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c7cff57f39d131b9234df352dd500e933fa5f9cf7905207ce024a2c58a87e98"
  end

  depends_on "node"

  allow_network_access! :test

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/worldmonitor --version")
    assert_match version.to_s, shell_output("#{bin}/wm --version")

    output = shell_output("#{bin}/worldmonitor call get_sources --view summary --timeout 15000")
    result = JSON.parse(output).fetch("structuredContent")
    assert_equal "summary", result.fetch("view")
    assert_operator result.fetch("summary").fetch("providerCount"), :>, 0
  end
end
