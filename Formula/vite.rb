require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.2.tgz"
  sha256 "00f0af48f845eb0465269ebdf681d7a670fbf36160efed5b3322be7233d34c3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ab7391ade85b48a782dd0a64bbf60ee42912b54214335c0653c0f603db673aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ab7391ade85b48a782dd0a64bbf60ee42912b54214335c0653c0f603db673aa"
    sha256 cellar: :any_skip_relocation, monterey:       "a53e57d7c1fb0b8d4e9be53cf9240a7253baaada4351d8b7bf628c452356e12e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a53e57d7c1fb0b8d4e9be53cf9240a7253baaada4351d8b7bf628c452356e12e"
    sha256 cellar: :any_skip_relocation, catalina:       "a53e57d7c1fb0b8d4e9be53cf9240a7253baaada4351d8b7bf628c452356e12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df1709265c107c86796dba3c7ed080d2ae731b8db62c7423ea5072656e04c2c"
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
