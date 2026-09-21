class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-6.0.0.tgz"
  sha256 "958821f50355ea13cd6f2272c3ca8b023388b14a917e279e0bf63f2547498d72"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "65795fe55d6fdc653ae0871b0248898bfbb6a59d33216247f4720f46d37576d6"
    sha256 arm64_tahoe:       "0931429f7e1c620ea713e95bcb801d93694c558c753f3399af44541d6d3edbdf"
    sha256 arm64_sequoia:     "509fa851b4b17d2a7cd6d23b28d9000865adfa517cdd8bcd90c6b6c7c77ce671"
    sha256 arm64_linux:       "9876df2e219cd51817475b705ae64887d070f2b2ad41e6a3a263d09035ba4eb9"
    sha256 x86_64_linux:      "5ce04c17d6218ae377fe348bd900cb6c9bbdc8fe4e70d72509f65ac4cc38441b"
  end

  deprecate! date: "2025-10-28", because: "uses deprecated node@20"
  disable! date: "2026-10-28", because: "uses deprecated node@20"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  # Using Node 20 due to issue with N-API 10 https://github.com/murat-dogan/node-datachannel/issues/333
  # and unable to use newer node-datachannel https://github.com/ThaUnknown/webrtc-polyfill/issues/9
  depends_on "node@20"

  def install
    # Install locally as `npx only-allow pnpm` in `ip-set`'s preinstall script fails in global mode
    system "npm", "install", "--omit=dev", *std_npm_args(prefix: false, ignore_scripts: false)
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/cmd.js" => "webtorrent"

    nm = libexec/"node_modules"

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
    pb = nm/"{bare-fs,bare-os,bare-path,bare-url,bufferutil,fs-native-extensions,utp-native,utf-8-validate}"
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
