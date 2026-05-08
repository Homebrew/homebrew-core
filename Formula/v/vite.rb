class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.11.tgz"
  sha256 "5987d4e176cd053b313e7bc92faa9b8f82190c73d8ebb5fc0379f0ecc572e4ac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8db4ad9df0afe00b24d09b333faa5b5720404a6dac460ede159129ecb94e6517"
    sha256 cellar: :any,                 arm64_sequoia: "41612ed64e0dc02e3e3b242eaf155621fdec7daf93a383b3c80031f7f2dc0d77"
    sha256 cellar: :any,                 arm64_sonoma:  "41612ed64e0dc02e3e3b242eaf155621fdec7daf93a383b3c80031f7f2dc0d77"
    sha256 cellar: :any,                 sonoma:        "24620f936caa2ea0fd3036698a218d9fb14fed12a9a05b63e503babfda0f5431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a14489ead60044f3e130515e25861ea54afba7839155e5fa31bff6e05fa52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "557d8dfaf4581273c56d38b40cce25ce4baaf0c2babea4b516d450558b6048de"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
