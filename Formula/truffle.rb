require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.2.tgz"
  sha256 "7c94b3fb542d49d93b22ba2c0e9d54ec837db55e2e3b46e1c4c7bbef3e7c0a97"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "cee9e6b54f088f00ba7704268528f8b33be4563c4daf47a1831ad1d14ab09171"
    sha256                               arm64_monterey: "df720e8ad75138359d58856cada14f3a0b2bfbaf25ec60027d866ec6fe28abec"
    sha256                               arm64_big_sur:  "6d25a544e26992aad110893904804da5bc2644bed20531fe721859eb3a09fbb7"
    sha256                               ventura:        "4315ac9fb5ba2f937ab4ca00a2a98e0cb2dbad27eb79767f2fc52bc637a43f5a"
    sha256                               monterey:       "73a3fb780b0560a6f866ff1e3eb330641cc95c34b70b8bcba8af268d4b6124ea"
    sha256                               big_sur:        "00974f1f3ff56d0fe50d0475c11e8d9b54b99d8e5b9521bb67d978781507c81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f045e07e31cff0881644290886b86050df83f4feaed2bb128a8feae0b339382f"
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
