class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-6.0.0.tgz"
  sha256 "958821f50355ea13cd6f2272c3ca8b023388b14a917e279e0bf63f2547498d72"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "d0eef5abf6e01e1bfa8330bce0f2cbdf45afa4749480e07cc08ea3e3c7efb2b0"
    sha256 arm64_sequoia: "1d37da2d7d7865819ac6a77548adefaec6d638e8a3054d0dc85d6199512b7de7"
    sha256 arm64_sonoma:  "dc73ce373313a7c9a4bb7d6cf1efadb9d8657945091264bcf966d4429cf866aa"
    sha256 sonoma:        "3f933ceee91ee375a014da72820f676a6e8ecaa200090d5a3f3229a5f9a0c7ab"
    sha256 arm64_linux:   "4cc65c1a5649f21e8cbb982334bb10854bccfc40a24df872deabda523692beae"
    sha256 x86_64_linux:  "aef5a3aebb182b7486a37ed9fba1e097c5a64f712b2ba973b2446c758d8f6472"
  end

  deprecate! date: "2025-10-28", because: "uses deprecated node@20"
  disable! date: "2026-10-28", because: "uses deprecated node@20"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  # Using Node 20 due to issue with N-API 10 https://github.com/murat-dogan/node-datachannel/issues/333
  # and unable to use newer node-datachannel https://github.com/ThaUnknown/webrtc-polyfill/issues/9
  depends_on "node@20"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    nm = libexec/"lib/node_modules/webtorrent-cli/node_modules"

    # Remove node-datachannel dev dependencies which were installed via
    # `npm install --ignore-scripts --production=false` to build node-datachannel.node
    # Also remove prebuild-install which was needed at install time due to install script
    rm_r(nm.glob("node-datachannel/node_modules/*"))

    # Remove node-datachannel CMake build directory other than the final binary
    node_datachannel_release_dir = nm/"node-datachannel/build/Release"
    rm_r(nm.glob("node-datachannel/build/*") - [node_datachannel_release_dir])
    odie "node-datachannel.node not found!" if node_datachannel_release_dir.glob("*.node").empty?

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    platforms = ["#{os}-#{arch}"]
    platforms << "#{os}-x64+arm64" if OS.mac?
    pb = nm/"{bare-fs,bare-os,bare-url,bufferutil,fs-native-extensions,utp-native,utf-8-validate}"
    libexec.glob(pb/"prebuilds/*").each do |dir|
      rm_r(dir) if platforms.exclude?(dir.basename.to_s)
      dir.glob("*.musl.node").map(&:unlink) if OS.linux?
    end
  end

  test do
    magnet_uri = <<~EOS.gsub(/\s+/, "").strip
      magnet:?xt=urn:btih:9eae210fe47a073f991c83561e75d439887be3f3
      &dn=archlinux-2017.02.01-x86_64.iso
      &tr=udp://tracker.archlinux.org:6969
      &tr=https://tracker.archlinux.org:443/announce
    EOS

    expected_output_raw = <<~JSON
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
    JSON
    expected_json = JSON.parse(expected_output_raw)
    actual_output_raw = shell_output("#{bin}/webtorrent info '#{magnet_uri}'")
    actual_json = JSON.parse(actual_output_raw)
    assert_equal expected_json["tr"].to_set, actual_json["tr"].to_set
    assert_equal expected_json["announce"].to_set, actual_json["announce"].to_set
  end
end
