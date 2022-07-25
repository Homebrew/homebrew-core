require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.3.tgz"
  sha256 "a609a54fd6eecf4131f45cd787dd8eb799a954a4e3dd20269ad205a48e3775f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e1163fe664cb58578d72c896659c1a7fbbe5df3218f2f81c7520c892405fb97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e1163fe664cb58578d72c896659c1a7fbbe5df3218f2f81c7520c892405fb97"
    sha256 cellar: :any_skip_relocation, monterey:       "1f052e233485a9ddfb7eb870185852ef49b69bcf884f1e50de79abd6ba7f5072"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f052e233485a9ddfb7eb870185852ef49b69bcf884f1e50de79abd6ba7f5072"
    sha256 cellar: :any_skip_relocation, catalina:       "1f052e233485a9ddfb7eb870185852ef49b69bcf884f1e50de79abd6ba7f5072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bf1b722e9a60eed83ba5334fd432161ad55c9e13e246afb9782fc0819ea4c09"
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
