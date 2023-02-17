require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.1.2.tgz"
  sha256 "4e0ef65c8c358feaf59e336c10da5099f50b3abc94fe0689e8129d2b142970cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1128d8f16f4b0805c24c8a35e086c6466fdcb26d44212082bd98d424e037a58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1128d8f16f4b0805c24c8a35e086c6466fdcb26d44212082bd98d424e037a58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1128d8f16f4b0805c24c8a35e086c6466fdcb26d44212082bd98d424e037a58"
    sha256 cellar: :any_skip_relocation, ventura:        "20e9382a7eeceacc35cc975b0aad0e37b719680b63ef23cfcb44a0605dc53fb5"
    sha256 cellar: :any_skip_relocation, monterey:       "20e9382a7eeceacc35cc975b0aad0e37b719680b63ef23cfcb44a0605dc53fb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "20e9382a7eeceacc35cc975b0aad0e37b719680b63ef23cfcb44a0605dc53fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12d2409b5e68f327cb40e114751096fb00173bd4885df47dd98db1b4ced2756"
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
