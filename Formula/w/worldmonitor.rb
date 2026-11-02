class Worldmonitor < Formula
  desc "Command-line client for the World Monitor global intelligence API"
  homepage "https://worldmonitor.app/docs/cli"
  url "https://registry.npmjs.org/worldmonitor/-/worldmonitor-0.2.2.tgz"
  sha256 "74d7b9b0e60c09deeb2b99b659bb6cea4ecab3c755a7fd73774c2fb379bf3899"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3ba5c5f768fb668195363170ed8d12fad6539fc7dd79d91b434ed5d129836dc"
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
