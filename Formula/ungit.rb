require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.23.tgz"
  sha256 "d868b06d0a160773799577d09bad528cf011c74f18d521356a332208c99aa991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10a662739162e9eccd5e41fbacc6a7ed21b0e6f31ad7908b33608b98dd0036f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10a662739162e9eccd5e41fbacc6a7ed21b0e6f31ad7908b33608b98dd0036f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10a662739162e9eccd5e41fbacc6a7ed21b0e6f31ad7908b33608b98dd0036f3"
    sha256 cellar: :any_skip_relocation, ventura:        "5f1cc918a458c3c25635be952c1cec2ba185ceca6715504eac7f25465101b535"
    sha256 cellar: :any_skip_relocation, monterey:       "5f1cc918a458c3c25635be952c1cec2ba185ceca6715504eac7f25465101b535"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f1cc918a458c3c25635be952c1cec2ba185ceca6715504eac7f25465101b535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a662739162e9eccd5e41fbacc6a7ed21b0e6f31ad7908b33608b98dd0036f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 8

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end
