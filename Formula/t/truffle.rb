class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.5.tgz"
  sha256 "bbc24698fc9964cd80acc8952500f708ef18984096eba9e75f40db3486392347"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:    "8f995c388105f622043e56ba9ab48c436004b9aea99a3580b67a70ee504cb84a"
    sha256                               arm64_sequoia:  "faf61c11f0243979a4bed2ebccbfc71cd540b1d72faded9b7bbfc871bbd8ae74"
    sha256                               arm64_sonoma:   "92ad4c83b95c30319d61cfe06957a32f10b288c01cbcc8fec77dd1377d2f53ad"
    sha256                               arm64_ventura:  "7e859053402f47674c30baebf3b5aa05ad21609471ab14d222dd9aee2b62a3b4"
    sha256                               arm64_monterey: "dc749938200b0b6aed95ac1103daf87ac555b729862e55767163936f0b1c26e8"
    sha256                               sonoma:         "3f7dbf05369a67669711f1d7358446c46380a5caf38b599d1653156441d5e60e"
    sha256                               ventura:        "7fda9c9211a1884fe42f87dcdfe896eb35d8e5dd332e324d0fb25230417e3c1a"
    sha256                               monterey:       "ea609ec0150beda892f4bdad71aff910c78fbe91338798e8a6a65c37a0434f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "561cb47cb5d7ca64d71b9464c9fd356b06fccf878432c303ba6bbd5ddbf1b133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db01e2a5e1d9ab923419eafc7a0588dd02bca55f62310277838a41d4cc5c653"
  end

  # https://consensys.io/blog/consensys-announces-the-sunset-of-truffle-and-ganache-and-new-hardhat
  deprecate! date: "2025-11-22", because: :unsupported
  disable! date: "2026-11-22", because: :unsupported

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    truffle_dir = libexec/"lib/node_modules/truffle"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    platforms = ["#{os}-#{arch}"]
    platforms << "#{os}-x64+arm64" if OS.mac?
    %w[
      **/node_modules/*
      node_modules/ganache/node_modules/@trufflesuite/bigint-buffer
    ].each do |pattern|
      truffle_dir.glob("#{pattern}/prebuilds/*").each do |dir|
        dir.glob("*.musl.node").map(&:unlink)
        rm_r(dir) if platforms.exclude?(dir.basename.to_s)
      end
    end
    pattern = "node_modules/ganache/node_modules/@trufflesuite/uws-js-unofficial/{binaries,dist}/*.node"
    truffle_dir.glob(pattern) do |f|
      rm(f) unless f.basename.to_s.match?("_#{os}_#{arch}_")
    end

    # Remove incompatible pre-built binaries that have arbitrary names
    truffle_dir.glob("node_modules/ganache/dist/node{/,/F/}*.node").each do |f|
      next unless f.dylib?
      next if f.arch == Hardware::CPU.arch
      next if OS.mac? && f.archs.include?(Hardware::CPU.arch)

      f.unlink
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
