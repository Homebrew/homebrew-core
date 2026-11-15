class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.87.tgz"
  sha256 "9427489b455e752f32faacc9b0a4b264a6bd373d4e01133d2c813f80e0544019"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "96e29145a0521f0594fcc1948631d198e63e8aa2b1e1e5f735c9718f17ae9f44"
    sha256 cellar: :any,                 arm64_tahoe:       "96e29145a0521f0594fcc1948631d198e63e8aa2b1e1e5f735c9718f17ae9f44"
    sha256 cellar: :any,                 arm64_sequoia:     "96e29145a0521f0594fcc1948631d198e63e8aa2b1e1e5f735c9718f17ae9f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c80524f77a4485e6097918eb7f572851ac7e592d70d6716a22ad1e9de6995c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "091534affc8299859977ebff362fc82874809db3f59d181d43484e5e47facd4e"
  end

  depends_on "node"

  allow_network_access! :build

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
