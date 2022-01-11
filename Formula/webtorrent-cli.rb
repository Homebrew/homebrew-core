require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-4.0.2.tgz"
  sha256 "7ad1c7d39b500cb58d1768e8d09337d1601c052a4a6f1d91bb29a4f8f1f44978"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "d0265f744d3d88141991939ce76ce844b71b82aa9002d31444a97ecf948e5259"
    sha256                               arm64_big_sur:  "c15e1dcb96e69c143c75671f100ee2b566756b8a7f7519bd84a4753246a303c5"
    sha256                               monterey:       "a0b5174808ff98cd8a1d68157deb2b9e90266a2e9a40bb0373a069dcd55b565c"
    sha256                               big_sur:        "445c94adfe4eac86ff02b6488c158f40651dfcbac81c5169b7be94d9e117eaaa"
    sha256                               catalina:       "34704644f1ed6f548cc021b701b72d4365d1bdbe8f5ff935a9f3f084d26e685b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca2fffcf58c185f4cf6e3adffe679743cc32b8b0a4d040f374f158d1a41a648"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/webtorrent-cli/node_modules/{bufferutil,utp-native,utf-8-validate}/prebuilds/*")
           .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    magnet_uri = <<~EOS.gsub(/\s+/, "").strip
      magnet:?xt=urn:btih:9eae210fe47a073f991c83561e75d439887be3f3
      &dn=archlinux-2017.02.01-x86_64.iso
      &tr=udp://tracker.archlinux.org:6969
      &tr=https://tracker.archlinux.org:443/announce
    EOS

    expected_output_raw = <<~EOS
      {
        "xt": "urn:btih:9eae210fe47a073f991c83561e75d439887be3f3",
        "dn": "archlinux-2017.02.01-x86_64.iso",
        "tr": [
          "https://tracker.archlinux.org:443/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "infoHash": "9eae210fe47a073f991c83561e75d439887be3f3",
        "name": "archlinux-2017.02.01-x86_64.iso",
        "announce": [
          "https://tracker.archlinux.org:443/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "urlList": []
      }
    EOS
    expected_json = JSON.parse(expected_output_raw)
    actual_output_raw = shell_output("#{bin}/webtorrent info '#{magnet_uri}'")
    actual_json = JSON.parse(actual_output_raw)
    assert_equal expected_json["tr"].to_set, actual_json["tr"].to_set
    assert_equal expected_json["announce"].to_set, actual_json["announce"].to_set
  end
end
