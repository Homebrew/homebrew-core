require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.54.tgz"
  sha256 "9772992fb12093a8b10f223bad2de783e5a0a074b8dc60e8439b42495bdcfb21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd4452b2468579a9f0d4c71dc3f5d73ee82b6b13a917c528596676d6d5dddd99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd4452b2468579a9f0d4c71dc3f5d73ee82b6b13a917c528596676d6d5dddd99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4452b2468579a9f0d4c71dc3f5d73ee82b6b13a917c528596676d6d5dddd99"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f93ac12bfdf867ad6ac31efc1943b1e09ddb0564019d91a29233305218bbdf0"
    sha256 cellar: :any_skip_relocation, ventura:        "7f93ac12bfdf867ad6ac31efc1943b1e09ddb0564019d91a29233305218bbdf0"
    sha256 cellar: :any_skip_relocation, monterey:       "7f93ac12bfdf867ad6ac31efc1943b1e09ddb0564019d91a29233305218bbdf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4452b2468579a9f0d4c71dc3f5d73ee82b6b13a917c528596676d6d5dddd99"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end
