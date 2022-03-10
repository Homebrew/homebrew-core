require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-4.0.4.tgz"
  sha256 "1633e620ec476eb35679f7c00cdc592facaf714e0f03afbd4abffe12a4849561"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "527a416531ee2a2b2c5df2a15d2983df7546059c73de4142bdc00744d3fe6b82"
    sha256                               arm64_big_sur:  "798c810d0489bd8d6664ec648c97d07407c5647bc1cbf7bd36de2804bf4b1154"
    sha256                               monterey:       "84bf71b3a59f9073f40ba6b4cd8d172d5039303922f8d9ee0d25241f4121c90a"
    sha256                               big_sur:        "3b266de81074ecaed9edda04a70a02731e3b8db3428a5b8de5f6e58fcd6f757a"
    sha256                               catalina:       "79a0dba49fdc352a4aca1641dc658140ca2eab2ae7fe41df7f10ecc25b4a3d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5735224576fb1a2f80b3c37d92795f52faa75e19a1f31bc380fa06e63ac7012"
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
