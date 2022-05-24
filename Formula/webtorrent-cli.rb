require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-4.0.4.tgz"
  sha256 "1633e620ec476eb35679f7c00cdc592facaf714e0f03afbd4abffe12a4849561"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "86c1ef7f88c13e56146713df15a33f85a5f355a6d91bf57c19780b5e7bb33278"
    sha256                               arm64_big_sur:  "9bf6bb347cfe2258439be6bc0a4648103de1fc7556cc43f909d6844f38731bcb"
    sha256                               monterey:       "82e63d789856811c2b77fc4243cd00bca469f9b73965a3f2d94d256ea4b31f62"
    sha256                               big_sur:        "8eb99390349f4c412182832ef688af98066ae25ec7dc7642871d119ed13a684a"
    sha256                               catalina:       "b67456ce6764331e165004e0a13cb41562bc9fb6c16b736c9ac34b1d9151792d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5460bb5cb67b8c4d3208df36d641d020c22c147209ff0e721ef734ebf4c6077f"
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
