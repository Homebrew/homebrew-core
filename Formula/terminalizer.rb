require "language/node"

class Terminalizer < Formula
  desc "Record your terminal and generate animated gif images or share a web player"
  homepage "https://www.terminalizer.com/"
  url "https://registry.npmjs.org/terminalizer/-/terminalizer-0.9.0.tgz"
  sha256 "512ec9dc30a5d0a5471223352fb14094222e684f72c5a9c23c196a4d90206fb0"
  license "MIT"
  head "https://github.com/faressoft/terminalizer.git", branch: "master"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/terminalizer/node_modules"
    node_pty_prebuilds = node_modules/"node-pty-prebuilt-multiarch/prebuilds"
    (node_pty_prebuilds/"linux-x64").glob("node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    node_pty_prebuilds.glob("#{os}-#{arch}/*.node").each do |f|
      next if f.arch == Hardware::CPU.arch
      next if OS.mac? && f.archs.include?(Hardware::CPU.arch)

      f.unlink
    end
  end

  test do
    system bin/"terminalizer", "config"
    assert_predicate testpath/"config.yml", :exist?
  end
end
