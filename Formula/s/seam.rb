require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.58.tgz"
  sha256 "4c9c7989f02506e241d0921921859b7b0774b6fed9ed3fe90983f9f877248e76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95b294db393a09b5ad522e2caf6d838d5da5057be7e8c4a4622d2df29a5c502c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95b294db393a09b5ad522e2caf6d838d5da5057be7e8c4a4622d2df29a5c502c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95b294db393a09b5ad522e2caf6d838d5da5057be7e8c4a4622d2df29a5c502c"
    sha256 cellar: :any_skip_relocation, sonoma:         "82e467fcc5944ff9d411a2acbdfa5ad32f7be7dbd88c8c153be3e09749975676"
    sha256 cellar: :any_skip_relocation, ventura:        "82e467fcc5944ff9d411a2acbdfa5ad32f7be7dbd88c8c153be3e09749975676"
    sha256 cellar: :any_skip_relocation, monterey:       "82e467fcc5944ff9d411a2acbdfa5ad32f7be7dbd88c8c153be3e09749975676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2da746fbe8decc9ebd66e5fdd3a985666a427f48613cb386229559ce193b59a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end
