require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.6.2.tgz"
  sha256 "87eb5156c6c5c0e017fe2866161f55da0262cdc51bffb35828613e14252addc3"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "8318a33ca2f150f01b377359c34dc79bd0ee6e36578dc1ac47ea678935f7f077"
    sha256                               arm64_big_sur:  "c91a8da2aab21aa85a45a03acf5c7dd506dd154804a963e8e8443249441c1f36"
    sha256                               monterey:       "8d0609172f67de28290b9bc17e1c0dcd6272d9cb3394ae81d69e6364aca35b6c"
    sha256                               big_sur:        "ae880ecc211032995d3707d3484f3f0be1b8b11f3fa37c0a60eb1fd9eb078f99"
    sha256                               catalina:       "24b861582bcb667c7bc0592d97bf300b6818d322764f6adf642d8f48935604ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb894abbb43356ecf06c9ecb66847718083051c188be2b04f273e214d9c47645"
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
