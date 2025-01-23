class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.5.tgz"
  sha256 "bbc24698fc9964cd80acc8952500f708ef18984096eba9e75f40db3486392347"
  license "MIT"

  bottle do
    rebuild 2
    sha256                               arm64_sequoia:  "faf61c11f0243979a4bed2ebccbfc71cd540b1d72faded9b7bbfc871bbd8ae74"
    sha256                               arm64_sonoma:   "92ad4c83b95c30319d61cfe06957a32f10b288c01cbcc8fec77dd1377d2f53ad"
    sha256                               arm64_ventura:  "7e859053402f47674c30baebf3b5aa05ad21609471ab14d222dd9aee2b62a3b4"
    sha256                               arm64_monterey: "dc749938200b0b6aed95ac1103daf87ac555b729862e55767163936f0b1c26e8"
    sha256                               sonoma:         "3f7dbf05369a67669711f1d7358446c46380a5caf38b599d1653156441d5e60e"
    sha256                               ventura:        "7fda9c9211a1884fe42f87dcdfe896eb35d8e5dd332e324d0fb25230417e3c1a"
    sha256                               monterey:       "ea609ec0150beda892f4bdad71aff910c78fbe91338798e8a6a65c37a0434f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db01e2a5e1d9ab923419eafc7a0588dd02bca55f62310277838a41d4cc5c653"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
          rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
        end
      end
    end

    # Replace remaining universal binaries with their native slices
    deuniversalize_machos truffle_dir/"node_modules/ganache/node_modules/fsevents/fsevents.node"

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
