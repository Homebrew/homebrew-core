require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-1.12.3.tgz"
  sha256 "e3e1db7e1d57d322e9263be1454e6af31e9713295fef0edb242d9ac0d97bf71b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b36cb12217855e7f846904787edff56b262191c3027dc80f695152197d877158" => :mojave
    sha256 "f742fef76f23303d2e3f00aecc58f0e330151395827b0c1e86965aea15de86fb" => :high_sierra
    sha256 "684233d167eda9cd325ea50016c1000ac4c4a19764a65da4810bebaa5f49a156" => :sierra
    sha256 "5fccaa04d58abeed5146887b970264758a3aff86a048766e9d40386bb5ad3dff" => :el_capitan
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
