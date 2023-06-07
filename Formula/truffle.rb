require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.9.4.tgz"
  sha256 "91c9d7eeb0b169814e796abe729cf1d5441ba7d283460e37c5a408ddfd001b26"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "f681d219a1c0a444634e96a1dca03a28431b5ed37db35d9d5bc156003d6c7e7b"
    sha256                               arm64_monterey: "47c978874051aaf68ce1f79d52dd431b517508711cf5dc612bb5cd61db37e18d"
    sha256                               arm64_big_sur:  "6da0bdd4c728119cdcbb6228b68f306118a57533c12f09396614dc723614987f"
    sha256                               ventura:        "3b2c6be7521a11243a9ef53e63c6095edc86d613e7e238795ae067534635bca0"
    sha256                               monterey:       "31daaebe310c56831437d10639b8cab5c488583769b44d210ef3b4d5be1e209b"
    sha256                               big_sur:        "9d182952df14b9fd07b9855ec370861d2af5c008b86332802e9b4218c84978d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c942d4cf8a64a9ead829c78d4a13ce2c05206bdd0482572acc803db47bda9bfd"
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
