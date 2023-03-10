require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.8.0.tgz"
  sha256 "d03e590bd47b0f43219f69e17c30dde1c23d2654e3c79d4ce1c356db3062b103"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "6afa3862e32a5ff0dc4a71cd5fb9a082a85195558dd5ef572b78cfd2733b5d37"
    sha256                               arm64_monterey: "72941e16722df6b58452a47f59de566eb1864d306ab46d5fa4714cc7ae1fe968"
    sha256                               arm64_big_sur:  "3629f4e3e234b57069e9e0521379ba3649d1c7339dfecbedeb4595bbc5025afe"
    sha256                               ventura:        "dff1dabbbe67146d9bc9ffcb865be47ccc6a0863da44149960d6f09ffd2b5b93"
    sha256                               monterey:       "5eee450c0254329f750f60841a7b11b452f957501fb5e2d55a411b30beff85da"
    sha256                               big_sur:        "0d326dee17b57aed3685a4d7b9a77035b2f4d70d6990fffd6d033c638dd37363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "396c10766720eb214a77d3008dff4fe832ffaa4465fa3a8568f2d619c04c068a"
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
