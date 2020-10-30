require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.13.tgz"
  sha256 "84849130bca8670f7abfcd285e99105aa982e7d09c09fb29d37c11b43fb6d250"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fc993795f40b280ea3cfc9178687d55d5ff85b945f8ea24eeebbf496bdc3611c" => :catalina
    sha256 "62cb99b06b418f103ad6c57128d577375e1ca214e60c2dde3392031ecdb94942" => :mojave
    sha256 "cc798c8c18069b63795b953566f1c4fc997ca48cfc81f1856e1d724d63972de3" => :high_sierra
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
