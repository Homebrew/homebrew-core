require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.5.30.tgz"
  sha256 "52506be08e5057c10fa05e3d19c879bca241d172d531e48f1ded162b1ebefd83"
  license "MIT"

  bottle do
    sha256                               monterey:     "98002dbc9de2d94c8b9c8b5f52bc270c06b5f3f0a52e7bf9f2f4ea43538b2076"
    sha256                               big_sur:      "ae31bf9eb686e8a8bbaaf87d306dfeb7af93f03ade5381aa33ff7116d2740b88"
    sha256                               catalina:     "29415be18c64be31abfdd822482d05a9927f2bcb89d9eab91e4d0151de1109a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d9131a259af1c1c59ca8a90ae9a64b6d5f7af57b9c7804dbc8a1dbeea735c90"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    truffle_dir = libexec/"lib/node_modules/truffle"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    %w[
      **/node_modules/*
      node_modules/ganache/node_modules/@trufflesuite/bigint-buffer
    ].each do |pattern|
      truffle_dir.glob("#{pattern}/prebuilds/*").each do |dir|
        if OS.mac? && dir.basename.to_s == "darwin-x64+arm64"
          # Replace universal binaries with their native slices
          deuniversalize_machos dir/"node.napi.node"
        else
          # Remove incompatible pre-built binaries
          dir.glob("*.musl.node").map(&:unlink)
          dir.rmtree if dir.basename.to_s != "#{os}-#{arch}"
        end
      end
    end

    # Replace remaining universal binaries with their native slices
    deuniversalize_machos truffle_dir/"node_modules/fsevents/fsevents.node"

    # Remove incompatible pre-built binaries that have arbitrary names
    truffle_dir.glob("node_modules/ganache/dist/node/*.node").each do |f|
      next unless f.dylib?
      next if f.arch == Hardware::CPU.arch
      next if OS.mac? && f.archs.include?(Hardware::CPU.arch)

      f.unlink
    end
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
