require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-3.5.3.tgz"
  sha256 "96d2d1c412aa35ca782d89f01c3b8780f5fee0b1ec6f8ea1a08b4f32aef6d93a"
  license "MIT"

  bottle do
    sha256                               arm64_big_sur: "b1d28693642a4856b3241d57604b2918c7ab0eb64f98d3626f456254e674153d"
    sha256                               big_sur:       "dd8d9a4cfccf0cbeb64e7946246913bb067f5ca830d07251f2d58df9cfdfe981"
    sha256                               catalina:      "47bf6855b2a07431d697ee870805ef31c6ea24a17e18060ac1a3ef12b12d989c"
    sha256                               mojave:        "a85ee06193f2b55e386db94cd769ac1d298cba1d25d81e0d4284f002e26fae79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c30545c971e15a61601d3ac47a022461245fab707b1a326ee25cb10c500f25"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
