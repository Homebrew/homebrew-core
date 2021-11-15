require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.14.tgz"
  sha256 "c1a37127f2e35ac7bc177f65010e33fa0fe0c6334d82718373c08b99135c1728"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36cadbd6b73bc2f0cc8199bcc11b984c75861c1b31a53c7f148e0c84572cead0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36cadbd6b73bc2f0cc8199bcc11b984c75861c1b31a53c7f148e0c84572cead0"
    sha256 cellar: :any_skip_relocation, monterey:       "bb34df046e536dd4338070d58e363aed3287ef40791efe54c670d1f229511bde"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb34df046e536dd4338070d58e363aed3287ef40791efe54c670d1f229511bde"
    sha256 cellar: :any_skip_relocation, catalina:       "bb34df046e536dd4338070d58e363aed3287ef40791efe54c670d1f229511bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d95bbb3c309464fe88bbd31498389c0f4a8ca6116332de449a12989c1aa036d1"
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
