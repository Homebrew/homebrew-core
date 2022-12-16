require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.0.tgz"
  sha256 "a221f08a9d57b20a621f81035e527bb2260cb90a63b27236524f7cd6d163d80b"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "40338c38fb4edc8ee827d01501afbc1700056a125e2be2d67a36af3b75f6f469"
    sha256                               arm64_monterey: "c7d33b0a54bb1d9a380ed55fc50bb26236f7119463025d1178dcae517b97e54e"
    sha256                               arm64_big_sur:  "fbe2f3c5ed28eeda51e311a99fa6d4efdf2f52d53b07fed56d411537f49bae2d"
    sha256                               ventura:        "3194829b1aedc589d4adfea5127f859c55eecdf71c59e5f60bed9f9c6771e49c"
    sha256                               monterey:       "1afbde08d532e097e644c1049d8a68dba9fa6bca1f97feded7f82aa30e74fe96"
    sha256                               big_sur:        "66baaf12e79b9ac696f3b3f626325f9d277cb91efc90dc0d5d247eba76d816e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73598e6bfba7ed9079384043789668255b2203d7d9c5dccb72370b34af0a825c"
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
