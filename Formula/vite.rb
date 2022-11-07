require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.2.3.tgz"
  sha256 "14b4f337f1425ca1ae80637aaabb6219b9fa04cd8bc19bd74c63cc31f885770f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e15b7330e71df1b09d894986bc25f12dc6077a9da6ee377a7ccf749d94262596"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e15b7330e71df1b09d894986bc25f12dc6077a9da6ee377a7ccf749d94262596"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e15b7330e71df1b09d894986bc25f12dc6077a9da6ee377a7ccf749d94262596"
    sha256 cellar: :any_skip_relocation, monterey:       "b39e03373dc29485d616df85c98895bf2b7f6cb8c0aa12568c504da2d024c8c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b39e03373dc29485d616df85c98895bf2b7f6cb8c0aa12568c504da2d024c8c4"
    sha256 cellar: :any_skip_relocation, catalina:       "b39e03373dc29485d616df85c98895bf2b7f6cb8c0aa12568c504da2d024c8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93af704ac299d1d64111ea97577a293131795e766174a554eab562ddc5ec80c8"
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
