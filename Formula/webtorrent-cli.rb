require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-3.4.0.tgz"
  sha256 "5cdd9591457b2fe531236871955db1b4763f811b729dedd528ad7a494ef029c6"
  license "MIT"

  bottle do
    sha256                               arm64_big_sur: "5e66c53b50aca2d52d459aa3689bec111773ac177dfadc30f151a63bcea4c2b0"
    sha256                               big_sur:       "32fd20bc3ed48f3058aa96365ff67f82d928319a820f9a1deb008a7c50d3094b"
    sha256                               catalina:      "64a42c8bb84df5376c2c9d075b9cafa20c4b4f30abf348b51813bd5a6c330380"
    sha256                               mojave:        "5bcea35b2ff4c65bb4ede15928781cbd8de63cc72f8a46ef99e7ccb3f369d240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "048e7ae719982d9328112d336f0c501bfdf2fec5599f3b692dfb66dc928b6067"
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
