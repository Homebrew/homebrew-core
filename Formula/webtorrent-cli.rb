require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-3.4.0.tgz"
  sha256 "5cdd9591457b2fe531236871955db1b4763f811b729dedd528ad7a494ef029c6"
  license "MIT"

  bottle do
    sha256                               arm64_big_sur: "508b61995f4ae77ff51441e9c4188ba5d71542fdc201ea5d7efb15651e864fa6"
    sha256                               big_sur:       "339d79aae8244348eb84b4148f2959bb8de5dd69faa9b9dd66103c6d32eb7c96"
    sha256                               catalina:      "37a508c9b2382caf9bb27439f4c44c847de0b817cd32085d5f35799b5d937f7f"
    sha256                               mojave:        "ee64e9b7681c50255bc07787cf0089c383913c18603c244e1f92f26029b3dc87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3be60bd989ef39b3340e55110f174c041fcf74a12ce10b7cd062a7160ed953b"
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
