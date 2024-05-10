require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.26.tgz"
  sha256 "3a5640949faecab900c2fa82b662d42aa66596c2e24352814684407d0cf518b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e65bc0c2b45f341c3c749e76f962073ba1d9bcdcaf62b1d312f0d52078ee3038"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e65bc0c2b45f341c3c749e76f962073ba1d9bcdcaf62b1d312f0d52078ee3038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e65bc0c2b45f341c3c749e76f962073ba1d9bcdcaf62b1d312f0d52078ee3038"
    sha256 cellar: :any_skip_relocation, sonoma:         "def35d1320fab5ec25c27c8b768d03a82b37124feafcbaab28f2b34acc88d115"
    sha256 cellar: :any_skip_relocation, ventura:        "def35d1320fab5ec25c27c8b768d03a82b37124feafcbaab28f2b34acc88d115"
    sha256 cellar: :any_skip_relocation, monterey:       "def35d1320fab5ec25c27c8b768d03a82b37124feafcbaab28f2b34acc88d115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65bc0c2b45f341c3c749e76f962073ba1d9bcdcaf62b1d312f0d52078ee3038"
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
