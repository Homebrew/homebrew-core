require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.2.0.tgz"
  sha256 "970cdc6d2a7c333da8dfee33625011e28dc6ad7800bc35ade733a0671d401c19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44fe68d4aaa54ed3f1486d2c05a909f3273e011684264d70617cbe0ed31424a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad079a27d3ab1a0ba6e34866038edcc34a562dd46c229d3602a5c83abbf6c0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad079a27d3ab1a0ba6e34866038edcc34a562dd46c229d3602a5c83abbf6c0d"
    sha256 cellar: :any_skip_relocation, monterey:       "d75700886c224d539d39397d328540f2bc31888b53bbc964ebe489f0788bd74f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d75700886c224d539d39397d328540f2bc31888b53bbc964ebe489f0788bd74f"
    sha256 cellar: :any_skip_relocation, catalina:       "d75700886c224d539d39397d328540f2bc31888b53bbc964ebe489f0788bd74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba472aaeeeeb3491f6286c6a08cdbeedba6d557dda0196a79ff58690a0efc65d"
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
