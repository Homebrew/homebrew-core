require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.6.1.tgz"
  sha256 "557d7cc99af79ae8135ab105aa372716aeff6c5ea33b09a897fcb64f1a7df6ac"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "3cc198fca98c9a200976d255ce2bc71891545c466299e0c2e52ab01fa1e8d9ec"
    sha256                               arm64_big_sur:  "0f71dea7b9deed8888d6f2ec880adfd1d3fe903628599480f6f62d932548bad1"
    sha256                               monterey:       "430acea7adfc94ebf4a4b2d6ad497311a7386f22c8b997f4a75a624eecf8c5aa"
    sha256                               big_sur:        "ff90a3e0407e516c4185e3a528c3aefee7bf4220149c5cb1a59dadc0ce5b5f7e"
    sha256                               catalina:       "a269a433c0eef7ccd7ce2f6482c39efbbcb0a202e80cecab1312d42060729a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16cf5b8d64ba3597b6fad3462d7f363a0c988056af53883b4bb17b02bf6de97a"
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
