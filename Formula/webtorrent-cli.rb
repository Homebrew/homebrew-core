require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-1.12.3.tgz"
  sha256 "e3e1db7e1d57d322e9263be1454e6af31e9713295fef0edb242d9ac0d97bf71b"

  bottle do
    sha256 "6fbb55968853c2b24de34a5384f9f72741510027e9caa79b561e4eaf9d45c17a" => :high_sierra
    sha256 "fdb996ba461d104d7d544598d1a447eb7fb1717f5fcbca21ec7c76d59e4310cb" => :sierra
    sha256 "3af31f91caf30b82dcd19f491d6fbb9a58255e0d19de6ed8c0e38c3c1a1b29d9" => :el_capitan
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
