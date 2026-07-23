class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.85.tgz"
  sha256 "5730d4745f908781305beb1ad86e14fd00865e4b4f5a414c695112b6871ea410"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47bd2a61ac5947c9a2b913ba805c024a685d63764c9c7c7ab97c1ac7a055142e"
    sha256 cellar: :any,                 arm64_sequoia: "9d6a0f00f435351816b9189b1c9464cdc0df650beb5eba27b3a99d0e8b854648"
    sha256 cellar: :any,                 arm64_sonoma:  "9d6a0f00f435351816b9189b1c9464cdc0df650beb5eba27b3a99d0e8b854648"
    sha256 cellar: :any,                 sonoma:        "d26d2ee94e8324d2e26195d9b93b8197c1e6902a5bda9437c2321e5e06839e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2c7a3fc905f2eb8c80d40fe51fc087519fea1257bc6b55a4dd56cb46224baaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04faa8f0471bd76c8e9b1e0eb14fc9e56c8210f069606d581e45e0f194a9bb7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/yuque-dl/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
