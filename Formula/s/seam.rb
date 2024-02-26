require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.41.tgz"
  sha256 "7c8972e9d05bc679399d7bc2ef26bdb094ba22841ce76bdc9139666c236f1dde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd35c1f389cc8fca48ac86fd96e031ec745a3d93ea75479f6b010a8c3f641f2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd35c1f389cc8fca48ac86fd96e031ec745a3d93ea75479f6b010a8c3f641f2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd35c1f389cc8fca48ac86fd96e031ec745a3d93ea75479f6b010a8c3f641f2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e264b0a3f419594cd370f15794dde81259508c956e9333cda955b0c398975683"
    sha256 cellar: :any_skip_relocation, ventura:        "e264b0a3f419594cd370f15794dde81259508c956e9333cda955b0c398975683"
    sha256 cellar: :any_skip_relocation, monterey:       "e264b0a3f419594cd370f15794dde81259508c956e9333cda955b0c398975683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd35c1f389cc8fca48ac86fd96e031ec745a3d93ea75479f6b010a8c3f641f2d"
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
