require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-1.11.0.tgz"
  sha256 "682f4c5f21aa40974fab3c2e2ea032f0e4af2c09472c9f934efa58e4514b8a03"

  bottle do
    sha256 "7a7c8ea2a2205599d99b767cf0eb6b2bda52c2e1327887e337c53d577fbb1e25" => :high_sierra
    sha256 "bef775f7a8c307010d204911fcd5f682af88e97d94751cf2af257c894dead67b" => :sierra
    sha256 "468d90082e2916c432816e26cd9455d71f12899617e1c187a2f0569daa8a9800" => :el_capitan
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
      &tr=http://tracker.archlinux.org:6969/announce
    EOS

    assert_equal <<~EOS.chomp, shell_output("#{bin}/webtorrent info '#{magnet_uri}'")
      {
        "xt": "urn:btih:9eae210fe47a073f991c83561e75d439887be3f3",
        "dn": "archlinux-2017.02.01-x86_64.iso",
        "tr": [
          "http://tracker.archlinux.org:6969/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "infoHash": "9eae210fe47a073f991c83561e75d439887be3f3",
        "name": "archlinux-2017.02.01-x86_64.iso",
        "announce": [
          "http://tracker.archlinux.org:6969/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "urlList": []
      }
    EOS
  end
end
