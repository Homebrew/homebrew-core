class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-5.1.3.tgz"
  sha256 "54a53ecdacbccf0f6855bd4ef18f4f154576f8346e3b7aef3792b66dd5aaaa1b"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "2f51039320fd1f4c65622c16387998ea51c75e9cc686f2f28e3f4c8d487948ee"
    sha256 arm64_sonoma:  "5426246ae8ca317d1400c9c303b8b31fb38ccbe53c29c450b6258203d0ab4aa1"
    sha256 arm64_ventura: "255d4b3c1c1f5637c67841c04df5b77d515f2f3aef49fbebd9c1d701b853bb63"
    sha256 sonoma:        "2e1bb535aa93a68bbaa5da0dd2317ce6e76b7b2ddc325ac13052214fac5fe4c2"
    sha256 ventura:       "e690cb2c937766b9d500d255f79518937ac010c12a35586f4739e012a7d950b1"
    sha256 x86_64_linux:  "7684212b75eba13057dada394e1658bfb06d061b67da5e90809837c590eb1eb3"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    nm = libexec/"lib/node_modules/webtorrent-cli/node_modules"

    # Delete files that references to the Homebrew shims directory
    sb = nm/"node-datachannel/build"
    rm [
      sb/"CMakeFiles/CMakeConfigureLog.yaml",
      sb/"CMakeFiles/rules.ninja",
      sb/"CMakeFiles/3.31.2/CMakeCXXCompiler.cmake",
      sb/"CMakeFiles/3.31.2/CMakeCCompiler.cmake",
      sb/"_deps/libdatachannel-subbuild/CMakeLists.txt",
      sb/"_deps/libdatachannel-subbuild/libdatachannel-populate-prefix/tmp/libdatachannel-populate-gitclone.cmake",
      sb/"_deps/libdatachannel-subbuild/libdatachannel-populate-prefix/tmp/libdatachannel-populate-gitupdate.cmake",
      sb/"CMakeCache.txt",
    ]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    pb = nm/"{bare-fs,bare-os,bufferutil,fs-native-extensions,utp-native,utf-8-validate}"
    libexec.glob(pb/"prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
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
