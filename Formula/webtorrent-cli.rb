require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-4.0.0.tgz"
  sha256 "d45e495d0318a9d483f6ef57f020bff52740396939c6ef25954fad4a10f91045"
  license "MIT"

  bottle do
    sha256                               arm64_big_sur: "e1b22e1d943e803b3d1734ac720aaca1f40ded5b97fbdcf25fb5a8c7b86c5c95"
    sha256                               big_sur:       "04d0d4a06c629085f960572037c04c92aef907220027f15788b20cb69edf6ab4"
    sha256                               catalina:      "a3b4e49ed8535a869e42a7e228c5617b7b2a62a24d3d76cdf9f7b6039df9a266"
    sha256                               mojave:        "cafaf0592ce6c23f452c63c94e615bb3c5db68977cf9ded91f4e4be79508c5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d945a5b25dfff5c28d3d6459698a051c4ea1bdaf8ba0b5b934f1bfc808b082a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    modules_dir = libexec/"lib/node_modules"/name/"node_modules"
    modules_dir.glob("*/prebuilds/{win32-,linux-arm}*").map(&:rmtree)

    arch_to_remove = if OS.linux?
      "*"
    elsif Hardware::CPU.intel?
      "arm64"
    else
      "x64"
    end
    modules_dir.glob("*/prebuilds/darwin-#{arch_to_remove}").map(&:rmtree)
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
