require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.7.tgz"
  sha256 "324995b64492f7dbb17bad558b0fa91d197f0a6d71326a6344c7049c7c7a29ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "4210b3b1082139f8d42e2b3e6388e477420c8e396088556183d9ce6d776219cf" => :catalina
    sha256 "c6b3457e7cda7771420163813257abba2d66fcd1c2a8b13707b423e27fab65c0" => :mojave
    sha256 "9a584dd96e46c15743a8e84bc5ceb3c9092369752f284d29b91df27b1768e97e" => :high_sierra
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
    sleep 5

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end
