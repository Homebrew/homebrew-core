require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.0.tgz"
  sha256 "765f9b203d500cfb16fb0789df193d87fda37af8870154ad2bf897bf0b74dbd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c69b488498cb1edf98389e9d39be58bfbb13dd0d48d1e15488824b6b0092b767"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c69b488498cb1edf98389e9d39be58bfbb13dd0d48d1e15488824b6b0092b767"
    sha256 cellar: :any_skip_relocation, monterey:       "b4aa79c18edd38930cf6cb39b61de7cb3cfad66f0f0152f78442f1286d05bfa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4aa79c18edd38930cf6cb39b61de7cb3cfad66f0f0152f78442f1286d05bfa5"
    sha256 cellar: :any_skip_relocation, catalina:       "b4aa79c18edd38930cf6cb39b61de7cb3cfad66f0f0152f78442f1286d05bfa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf2afaef3cd73016183fc7595d4f7634833ea015c43fd24cde3c838ad948821c"
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
