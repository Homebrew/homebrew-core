require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.10.1.tgz"
  sha256 "25eeb476d18add8bd26d80a3654bcb2fad4a4eb0344fa8c21cddb44ad611d668"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "db041286b72f16c407ab6af2744b8bb440e8fb6aaa4918b4d67bc3e1a1e5f5c6"
    sha256                               arm64_monterey: "3567e37dba0093d2a5629911f8dd8e7afe2172f1d4443a337c6e8bb30004d017"
    sha256                               arm64_big_sur:  "274ca085515b4e7e594bc211c3723bec5f18825b2816484d8b715d23021eae29"
    sha256                               ventura:        "3706427d31849d3a0e1bf5dddfd79c2d489006b1a4d29ddde3f195fe7ff51c6c"
    sha256                               monterey:       "1ddfa79a1f757e4214ef67e3a77ba3fe58d9a21e5aa7ea8239ad0e6ad0da869e"
    sha256                               big_sur:        "c11aff1747bd4173668c54e6d15e9ccb472537c7561f26b9d74166b146f193dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18746005bff5403901e53150ad3d9d3e25bf26b1ce5f78287cf9cf7b25f2f752"
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
