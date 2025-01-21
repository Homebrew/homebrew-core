class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1295.0.tgz"
  sha256 "24c8759cecbf6f294b2feff2adcb6c9ecb4cd6790e4daaa147ff572f7d0959bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90dd4245d38fa6f4b37ba1acb70de9b39a32bbdc55e53c55f0210940d8c96d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90dd4245d38fa6f4b37ba1acb70de9b39a32bbdc55e53c55f0210940d8c96d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c90dd4245d38fa6f4b37ba1acb70de9b39a32bbdc55e53c55f0210940d8c96d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "00a4990af78e15da31a8152f85780472b7414e0c331608ddb7d9244deaff4725"
    sha256 cellar: :any_skip_relocation, ventura:       "00a4990af78e15da31a8152f85780472b7414e0c331608ddb7d9244deaff4725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31afc63522500d6ce34a236aa6a34867ec237ddc4b79ea9a4a3ca3c4fb0fdfcf"
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
