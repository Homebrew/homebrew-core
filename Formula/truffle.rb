require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.5.15.tgz"
  sha256 "2167a744b9b046875ac75e048c0936ff7a627c273f3ecfb25373e06fc85631ad"
  license "MIT"

  bottle do
    sha256                               monterey:     "92195fe1c55b1c75e21d31444b4b102f5de62b8f6c63b68745ee91d90b9c1ba0"
    sha256                               big_sur:      "59bbd014769f96d93abcc6a7c31b3ec02fb098d8e937acfa8ef11cdfa0c27e82"
    sha256                               catalina:     "24a3f755bceb56ea67d0821f8c7738225b0f527ce40622c71274a1454a9667cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be1dc91dc96de713bf506d8fece22df6c2a77d266eb3fd3ddf2da22ad23e1c16"
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
