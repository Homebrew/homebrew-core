require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.0.tgz"
  sha256 "4c7e308f8359beb53588cc9e5b1d716b0fce3bfef00ddc5461f3a35e0ad9dc26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7342099459c3ec45d0ea68bfbb0171f0968c8524b10728828eceaf9366bea62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7342099459c3ec45d0ea68bfbb0171f0968c8524b10728828eceaf9366bea62"
    sha256 cellar: :any_skip_relocation, monterey:       "e59ca6e3e077ce4d1b1e710b7f0079a00135dcacf7eadc42c45040fd735b6492"
    sha256 cellar: :any_skip_relocation, big_sur:        "e59ca6e3e077ce4d1b1e710b7f0079a00135dcacf7eadc42c45040fd735b6492"
    sha256 cellar: :any_skip_relocation, catalina:       "e59ca6e3e077ce4d1b1e710b7f0079a00135dcacf7eadc42c45040fd735b6492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70f7ad8f0ac48243f542eac2fca43b882e8a9be0e1a5245dc0adea94d7c8d9d"
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
