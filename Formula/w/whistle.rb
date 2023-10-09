require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.57.tgz"
  sha256 "a50783a1278e5ef40fabe6e4b8ca27ac1a411bee18e0cfe30242a88a169bcb43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ded20fd07c676af69f6fc12e3361827b04f9ebd9376a9d0e2092b382368b596e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31e15e11a8985d3f6b29e14ce8e2971e4d8d18d6faaf92600088e80a047514c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e15e11a8985d3f6b29e14ce8e2971e4d8d18d6faaf92600088e80a047514c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31e15e11a8985d3f6b29e14ce8e2971e4d8d18d6faaf92600088e80a047514c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c12bf716c028504244d29eca518ec151762ffc9ebdd99c1704dff835347ca7b0"
    sha256 cellar: :any_skip_relocation, ventura:        "2e82dd7f3554aa37607949cce4d2069861ce9e3e2f5f6718610647d4208b4baa"
    sha256 cellar: :any_skip_relocation, monterey:       "2e82dd7f3554aa37607949cce4d2069861ce9e3e2f5f6718610647d4208b4baa"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e82dd7f3554aa37607949cce4d2069861ce9e3e2f5f6718610647d4208b4baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e82dd7f3554aa37607949cce4d2069861ce9e3e2f5f6718610647d4208b4baa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86 specific optional feature
    node_modules = libexec/"lib/node_modules/whistle/node_modules"
    rm_f node_modules/"set-global-proxy/lib/mac/whistle" if Hardware::CPU.arm?
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
