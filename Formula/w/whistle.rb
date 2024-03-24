require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.67.tgz"
  sha256 "a2dc32a59fb7596858ef7602753c816365e9c55642107711cccc4c69960516f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "784a603f456c85d413119517a9ad6e97251cc1abd894169e82cc23288892bfe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "784a603f456c85d413119517a9ad6e97251cc1abd894169e82cc23288892bfe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "784a603f456c85d413119517a9ad6e97251cc1abd894169e82cc23288892bfe4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c62b15d374b661a3454e6c07bb2be237ae2184dd9fdf8c33e20c0389fb9c49e"
    sha256 cellar: :any_skip_relocation, ventura:        "5c62b15d374b661a3454e6c07bb2be237ae2184dd9fdf8c33e20c0389fb9c49e"
    sha256 cellar: :any_skip_relocation, monterey:       "5c62b15d374b661a3454e6c07bb2be237ae2184dd9fdf8c33e20c0389fb9c49e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c62b15d374b661a3454e6c07bb2be237ae2184dd9fdf8c33e20c0389fb9c49e"
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
