require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.2.tgz"
  sha256 "a55b237d6f2190d8c587fcb7704a47f5bf46554491012d07bb3665f2305d593e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a4273ff5ec11687232a9847d1ec294d27ed309b7bdfae452877d17035de6189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a4273ff5ec11687232a9847d1ec294d27ed309b7bdfae452877d17035de6189"
    sha256 cellar: :any_skip_relocation, monterey:       "3dfe652062f1927797af3db87a13ece43d4243b4a7a87b4f1b64813d0bc7507c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dfe652062f1927797af3db87a13ece43d4243b4a7a87b4f1b64813d0bc7507c"
    sha256 cellar: :any_skip_relocation, catalina:       "3dfe652062f1927797af3db87a13ece43d4243b4a7a87b4f1b64813d0bc7507c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8221adae3c22df7cf60948da2ad40e11134dfc63fce838d561b24b473241ae3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end
