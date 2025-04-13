class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1296.1.tgz"
  sha256 "35d53f3a468df2a6c491b09b22195ea1082a00ac7a9f89f748e30d283479eb81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efbc7928d000eff7e92acdd42d9614b527a7d54bf8fc425aec29e697620db318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efbc7928d000eff7e92acdd42d9614b527a7d54bf8fc425aec29e697620db318"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efbc7928d000eff7e92acdd42d9614b527a7d54bf8fc425aec29e697620db318"
    sha256 cellar: :any_skip_relocation, sonoma:        "6128ebaf551bc458d4f20fb33f2e25c933b3f76b16680f32902a49b801db153b"
    sha256 cellar: :any_skip_relocation, ventura:       "6128ebaf551bc458d4f20fb33f2e25c933b3f76b16680f32902a49b801db153b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d849e4b959713d3aa46db12e82fdc501738d7d6047b6cc7b07c958981578bec"
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
