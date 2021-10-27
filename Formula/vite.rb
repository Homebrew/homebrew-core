require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.13.tgz"
  sha256 "b367474fe1bcb825acc5b74fffc05837e71f9be6b7b4e2319a4aa900005e9d7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d03a876f5ce279ed73904af05d105959715ffb1d0497e9fc78248ec592bbc1c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c0ccef307274d0c0a62c50c53f215ac2dfd573b12c0cd357ee5390ab9a42214"
    sha256 cellar: :any_skip_relocation, catalina:      "9c0ccef307274d0c0a62c50c53f215ac2dfd573b12c0cd357ee5390ab9a42214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d56ff9928df21b097ffd0d79ee91e903b04bb7f17f901826980be68eb6fe237"
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
