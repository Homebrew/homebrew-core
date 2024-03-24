require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.67.tgz"
  sha256 "a2dc32a59fb7596858ef7602753c816365e9c55642107711cccc4c69960516f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8acaaf98c78ce975f29b97e76d0e6fecc904561d24aafef30f84ce154ac92c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8acaaf98c78ce975f29b97e76d0e6fecc904561d24aafef30f84ce154ac92c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8acaaf98c78ce975f29b97e76d0e6fecc904561d24aafef30f84ce154ac92c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fa45ad10965f5d25d265d9762461c2fe9d97e9d43a88937bfdb32baaea4c05f"
    sha256 cellar: :any_skip_relocation, ventura:        "6fa45ad10965f5d25d265d9762461c2fe9d97e9d43a88937bfdb32baaea4c05f"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa45ad10965f5d25d265d9762461c2fe9d97e9d43a88937bfdb32baaea4c05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fa45ad10965f5d25d265d9762461c2fe9d97e9d43a88937bfdb32baaea4c05f"
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
