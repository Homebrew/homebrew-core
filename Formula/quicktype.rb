require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.19.tgz"
  sha256 "8c70dd594d134347a742053ef216138a25bb20eac4309ea7e83aa7962a0b4a92"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7cb6a4bd33b42d21e6101368594e3d8f5c0a88e30130bb4ccced0cd5c6e4e0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7cb6a4bd33b42d21e6101368594e3d8f5c0a88e30130bb4ccced0cd5c6e4e0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7cb6a4bd33b42d21e6101368594e3d8f5c0a88e30130bb4ccced0cd5c6e4e0f"
    sha256 cellar: :any_skip_relocation, ventura:        "762db51262324cbc0ab492c87f3b95d0b1e22e9cd77b8f85faf4f581da837194"
    sha256 cellar: :any_skip_relocation, monterey:       "762db51262324cbc0ab492c87f3b95d0b1e22e9cd77b8f85faf4f581da837194"
    sha256 cellar: :any_skip_relocation, big_sur:        "762db51262324cbc0ab492c87f3b95d0b1e22e9cd77b8f85faf4f581da837194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7cb6a4bd33b42d21e6101368594e3d8f5c0a88e30130bb4ccced0cd5c6e4e0f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
