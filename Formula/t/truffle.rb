require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.3.tgz"
  sha256 "9f916d813817c0a6c61aee67906b5da71e7c8ba9bcb091ff2342d02eb6177961"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "65ebcc6e38b47bb57c076917c7ee018371cbd01543947b90f4b917cc4cfa59bb"
    sha256                               arm64_monterey: "9f10d887fe6dd38e74beb8760a4eb2b5c41873eab0533d9647a0bf2d8d3df6e9"
    sha256                               arm64_big_sur:  "26b4d63b5636983bc78427619299f0a4b5272dcdd54d312abca60d258bba94e0"
    sha256                               ventura:        "123c3f1b8af34c0c824c859bfe59d78be911a3a9035d6161b2054e6ce082fa32"
    sha256                               monterey:       "89a66c5d645fbd173fe225fa97af73911518e4415e092ffb84ee3a831ef67aad"
    sha256                               big_sur:        "ab14ef5fa6fa1e3648252917e642fe2c704b9987f23b0759b0906c89179c69da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7014e5a1597481ba6b08256f8c94d69129911963a1d51db57c96e2c30540c6a"
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
      node_modules/ganache/node_modules/@trufflesuite/uws-js-unofficial
    ].each do |pattern|
      truffle_dir.glob("#{pattern}/{prebuilds,binaries}/*").each do |dir|
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
    %W[
      #{truffle_dir}/node_modules/fsevents/fsevents.node
      #{truffle_dir}/node_modules/ganache/node_modules/fsevents/fsevents.node
    ].each do |f|
      deuniversalize_machos f
    end

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
