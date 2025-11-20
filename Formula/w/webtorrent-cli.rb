class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-5.1.3.tgz"
  sha256 "54a53ecdacbccf0f6855bd4ef18f4f154576f8346e3b7aef3792b66dd5aaaa1b"
  license "MIT"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "4f3bda6aa26bcf929db135e31c3fb3822ef250a7738438b4256c0706abc736b6"
    sha256 arm64_sequoia: "2455bfe4e4762ecf6d4110b6e3db3160d6b6f7ed455062fea983f230b127b127"
    sha256 arm64_sonoma:  "89c52aa581dbbf5676cb8fd1e7837f9e7830b35ee33fda3b1dba4b37484b33d7"
    sha256 sonoma:        "6ba628acde26d8a0b2c90c235cbb4b55739c860781a3974160556e5bfc4169f6"
    sha256 arm64_linux:   "a44f21e2d862608a8087a7ec516b56d181ebdf61246c2ac7c21d92af9a3b38db"
    sha256 x86_64_linux:  "9760ecc99259186588ceccdfa3e25a12296ba01b852c2c3411c2c7eeadc3e0ee"
  end

  deprecate! date: "2025-10-28", because: "uses deprecated node@20"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  # Using Node 20 due to issue with N-API 10 https://github.com/murat-dogan/node-datachannel/issues/333
  # and unable to use newer node-datachannel https://github.com/ThaUnknown/webrtc-polyfill/issues/9
  depends_on "node@20"

  def install
    # Workaround for CMake 4 until node-datachannel -> libdatachannel -> plog is updated
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    nm = libexec/"lib/node_modules/webtorrent-cli/node_modules"

    # Remove node-datachannel dev dependencies which were installed via
    # `npm install --ignore-scripts --production=false` to build node-datachannel.node
    # Also remove prebuild-install which was needed at install time due to install script
    node_domexception = nm/"node-datachannel/node_modules/node-domexception"
    rm_r(nm.glob("node-datachannel/node_modules/*") - [node_domexception])
    odie "node-domexception not found! Check if it is still a dependency." unless node_domexception.exist?

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

    # Replace universal binaries with native slices
    deuniversalize_machos
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
