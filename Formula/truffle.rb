require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.6.3.tgz"
  sha256 "69290c94c50324af492f3d401a37140ecb1464396fb1b343efe97d4c9434db14"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "08c4cfe166a7686213d768b6363000f674d21c342c675b9534bfe35b579fa527"
    sha256                               arm64_big_sur:  "4749b47756237a9222ab62c741d556118f5eb7b00da0adf33e87fd98c5b7c8b9"
    sha256                               monterey:       "851b6afae34f5ec915999bf1390b1ed3c093e693b351904cf7bd4b15c7aba6a5"
    sha256                               big_sur:        "18690e43645bbe3104da7766182b3a97c5c2bf86a1b538d21ec4b4945e870ba8"
    sha256                               catalina:       "c107381cd72486e7bb2a6c765649cfde284e61a70ba6f6a9e5b5959fc166ea88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5750d9366c0e8786fca2cc07ba99855e92af860e187c13311ab93d645e7be1d8"
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
