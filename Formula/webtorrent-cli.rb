require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-4.1.0.tgz"
  sha256 "3b7bac7470e65540e45ed92b8b8d70008bbeca36bf96e81318c15bb9dee8b942"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "be8479b3f65c2a5c11794f53d04ee02357a76bf3c65f5bc410ffc09e805906f8"
    sha256                               arm64_monterey: "0e582b5e95bd7ae1462caca1b66e796fa83553b75dcf9c1b98b7e4e36f2f57bf"
    sha256                               arm64_big_sur:  "4658471f872e03c58d8f1ace044942a3debb7e6ad9dbf2a1ac9546e93efde890"
    sha256                               ventura:        "7fabff21cbe0391c790a9c05b0a98694ce054223981e012c1d0e65932ff8f63a"
    sha256                               monterey:       "257f5b960d1291aa153aff64eb1785ae36512bb78516d7d2d132d52a9ff44671"
    sha256                               big_sur:        "3dc242aefbede7812f1bf60486f7f6627590942b96e44af31197cfaf088e7d0f"
    sha256                               catalina:       "066aab7a937b40b19e50cc2efe6e336aa89dccbd958022d79e8956a10aa4eaa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b87f6ede3b7fa60052d477c30c12c72f2cf0d2c50223376d05579c5f43e7ee1"
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
