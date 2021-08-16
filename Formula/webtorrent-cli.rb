require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-3.5.4.tgz"
  sha256 "017d2880e88f64984cec5be4387f03bbd425f20b3adf599e8d2e2e37a31b3d50"
  license "MIT"

  bottle do
    sha256                               arm64_big_sur: "6f053e4455068ec7a4fff394ebead527078a4a092ced5d80572962c595a23b88"
    sha256                               big_sur:       "bb15d36ea3a989c9d238df5c8e0236bdfbc069bf4dd057b5b1088da7ae94e89d"
    sha256                               catalina:      "3f9ae728fe1cd50d0ded0cf35681c20b5b49af2afeb80ec4e2d0f1fba73652d6"
    sha256                               mojave:        "57f76ff00f3368ae837b137c62d6836545023c2856291e8bae0f513aa1481eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9904449af9740c9f04d03b9f2c19c54eb2b60cdfb1adc8fcfde0c8df4c969b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    modules_dir = libexec/"lib/node_modules"/name/"node_modules"
    modules_dir.glob("*/prebuilds/{win32-,linux-arm}*").map(&:rmtree)

    arch_to_remove = Hardware::CPU.intel? ? "arm64" : "x64"
    on_linux { arch_to_remove = "*" }
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
