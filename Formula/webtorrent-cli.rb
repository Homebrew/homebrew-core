require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-3.2.1.tgz"
  sha256 "0e2222d593069c1d10c20e7954426c7b70a5c7c2d38a2ae8310c232a03e730c6"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "10f51f2af1b7cf40eb078d27f1176f63e920bb93d617f393ed41230f088eaeb2" => :big_sur
    sha256 "60cdc0a2f395beda3dee530f46b0d3fd6308cd178dc04ca41c4572d12912df69" => :catalina
    sha256 "ac4d1d3d6c92aa23de4a7283a960917254ca5a9958f108e972ea06a328b72dfa" => :mojave
    sha256 "b3a637a7f8f1598e9a3ca7dc356da01b5ea4c0d761df3f9645853574de9ba86c" => :high_sierra
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
