require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.8.2.tgz"
  sha256 "26d0fcb1ea24a4cf4841c65d15214f428933d24da359279dc7061d7b15ab43a9"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "74860c68a31ab250fa6955e865a08529b5832488df6502ede74a69a5cb2c9d7a"
    sha256                               arm64_monterey: "af726a9eb2a8f3cf751a4a8c14cecface981dbb920e295261e6faf3fcba76f93"
    sha256                               arm64_big_sur:  "53ad3154543507f3abe3e345939784860bcfeca91762d96380ec3ceebe57c928"
    sha256                               ventura:        "9a6cb706e8fcfe3959b7c8eb693faff35d286f3846149c4cc07ab0e20f43a05c"
    sha256                               monterey:       "0602ff528b38ed5df5b1cd425f0bd773d0c76a6dbcfb37f30b3619775d338545"
    sha256                               big_sur:        "32dccdd54b13aa59642f89b4e959b066845104597eba2dccce57d5b7c81a3926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a6204a9e9de8672537ebef083e811db31c33117a9fc240d7e67b4390f9ce21"
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
    truffle_dir.glob("node_modules/ganache/dist/node{/,/F/}*.node").each do |f|
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
