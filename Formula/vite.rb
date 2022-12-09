require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.0.0.tgz"
  sha256 "6863d7daf91f82d741c14303b1ed0ba5812f626aa0ea01a4bb7d7c975432746c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9774f181d19fe93b4db994e1420ee887b7f0d94a5d195e3f7697ab50ea8883eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9774f181d19fe93b4db994e1420ee887b7f0d94a5d195e3f7697ab50ea8883eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9774f181d19fe93b4db994e1420ee887b7f0d94a5d195e3f7697ab50ea8883eb"
    sha256 cellar: :any_skip_relocation, ventura:        "eb9028875c330eb55d69d55d6fe99fa6f7a291beeec59226ad42f74b4fa627ad"
    sha256 cellar: :any_skip_relocation, monterey:       "eb9028875c330eb55d69d55d6fe99fa6f7a291beeec59226ad42f74b4fa627ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb9028875c330eb55d69d55d6fe99fa6f7a291beeec59226ad42f74b4fa627ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c626de352f746a5c3697e090c0f7014617bba05d05a2a1d7913607c1147171"
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
