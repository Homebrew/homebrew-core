require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-3.0.4.tgz"
  sha256 "5102f46937056db4e1268bc9ce6244435d0b3fab2dc5973911ecf5db4e372b8d"

  bottle do
    sha256 "e2c73414925c70265f2b60fc20aabaa24ad8513fdfa1db350fd52216283c1976" => :catalina
    sha256 "feb8ebedf0ae71e606138a3aade95976433bbf97066a45bbb77b7667b7940ecd" => :mojave
    sha256 "f8ce4a50913b23cf1f8d587d7fc51fbb071a6fb44d34be6b005a47d6cc20f435" => :high_sierra
    sha256 "01b1f9ab124ec3310f09f202d98fdc03a4a8a4fc969a5304da464faadf04bf5e" => :sierra
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

    assert_equal <<~EOS.chomp, shell_output("#{bin}/webtorrent info '#{magnet_uri}'")
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
  end
end
