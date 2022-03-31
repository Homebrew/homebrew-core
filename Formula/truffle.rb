require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  # Added to `mismatched_binary_allowlist` due to randomly named binaries in
  # libexec/"lib/node_modules/truffle/node_modules/ganache/dist/node" directory.
  # TODO: Check in future updates if possible to do one of following:
  # - Remove from allowlist if DSL available to detect ELF/Mach-O type to delete binaries
  # - Remove from allowlist if filenames have OS/Arch information
  # - Update allowlist if support is added for restricting to specific directories
  url "https://registry.npmjs.org/truffle/-/truffle-5.5.6.tgz"
  sha256 "c678ca5e2372898d68cd2a5da59dc53007a616989f226a58c88fa8962ba5cf22"
  license "MIT"

  bottle do
    sha256 big_sur:  "c39fe4aef87c1c78a58b1d7dd791519e2e608a9b1eddf9c4865c4a42626f3c23"
    sha256 catalina: "dd0c6c697882c291dd6e697ed430f2c864a5f1ebe38544a3d563507c5dc5dea7"
    sha256 mojave:   "5b19919e36101ef6cf0020a3a75b8087a5a766644138ebd8a08893b9765503cf"
  end

  # needs fsevents>=2.2.2 for Apple Silicon: https://github.com/fsevents/fsevents/pull/350
  depends_on arch: :x86_64
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove log files with references to shim paths
    truffle_dir = libexec/"lib/node_modules/truffle"
    (truffle_dir/"node_modules/ursa-optional/stderr.log").unlink

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    %w[
      **/node_modules/*
      node_modules/ganache/node_modules/@trufflesuite/bigint-buffer
    ].each do |pattern|
      truffle_dir.glob("#{pattern}/prebuilds/*").each do |dir|
        next if OS.mac? && dir.basename.to_s == "darwin-x64+arm64" # universal binaries

        dir.glob("*.musl.node").map(&:unlink)
        dir.rmtree if dir.basename.to_s != "#{os}-#{arch}"
      end
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
