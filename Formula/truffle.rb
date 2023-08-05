require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.2.tgz"
  sha256 "e23937734dd7e56d3235919d9aae1ef1b1d96a804bc176947a5f6ba49c7739dc"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "d55b8bd218832bcfd07e0e2827d46bb87b7bd28df8b45e76a5d9986b1a639cda"
    sha256                               arm64_monterey: "1e8d38a85b7975b335365c9b3e86af8ea2a8140afbc8f6e5d23919e2c484d03f"
    sha256                               arm64_big_sur:  "34eb63fb7464eeb653f13aef74b0131cee6796a2e462b68c5c77d6031c07897a"
    sha256                               ventura:        "74ddf1f440084a859fc915057b52714a088b9be5ce2dae013bf840348b46789a"
    sha256                               monterey:       "79fff415145c2bd382536ca04183e9a0abe92d6c6987f0fc83a7193beb14d277"
    sha256                               big_sur:        "d803577931ae57ee973365921deedd6a88cf96bf6a6322c3c8592efce1c88f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce42c43028663072780a16bace38a0fddae5bf8df5a869818c96033fdca9a4d6"
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
