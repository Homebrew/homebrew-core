require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.5.20.tgz"
  sha256 "d2062c5ba8ba177cd2768ab7c411310174b9ed504905f5c72b54089e39f22ebe"
  license "MIT"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256                               monterey:     "98002dbc9de2d94c8b9c8b5f52bc270c06b5f3f0a52e7bf9f2f4ea43538b2076"
    sha256                               big_sur:      "ae31bf9eb686e8a8bbaaf87d306dfeb7af93f03ade5381aa33ff7116d2740b88"
    sha256                               catalina:     "29415be18c64be31abfdd822482d05a9927f2bcb89d9eab91e4d0151de1109a6"
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
    if OS.mac?
      truffle_dir.glob("node_modules/ganache/dist/node/*.node")
                 .each { |f| f.unlink if f.dylib? && f.archs.exclude?(Hardware::CPU.arch) }
    end
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
