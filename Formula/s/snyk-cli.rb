require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1286.0.tgz"
  sha256 "b37299d0dffbca230935db703c97738d7e10eff36cda7f91f13254d36e6ae29e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df8efb741ca1bd879ba76334f2c46b621578e5e0503022dddd9e2656c447dcb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a64fd7a4616a4a3115e9e2f62872b7a44d117b4597d069be1401b59e9e0d735"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "982e35d9f357780287e826edf6f6b474c7582113f173ae3ee6537e6fa713086f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e43916e819f453018933c9756494f34a6729bb2cc472fba7751f8590fa69c24"
    sha256 cellar: :any_skip_relocation, ventura:        "6f5279e6a92acd2df95c1f2b6382fbf4608af6e42385d73a3212d66be2cc1277"
    sha256 cellar: :any_skip_relocation, monterey:       "5c9a1eef8a6ec3dcb3a390a61d55fc3ca823cb50dc9e525977be3ba088eeed9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9670a8a8d1cff657e8d58e8cad44e8e0a5237fbf08ab7b9cc2e13ae47226e6f1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
