class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-5.1.3.tgz"
  sha256 "54a53ecdacbccf0f6855bd4ef18f4f154576f8346e3b7aef3792b66dd5aaaa1b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "eb96a6e72f8c04344827b1d098938557cc110c58086e09e725bb6baa2c4f5439"
    sha256 arm64_sonoma:  "e0d8b93558e6684dd9b06357cdaec1bf680f34e825cda653e981674c6c31e796"
    sha256 arm64_ventura: "abe70e531a96d75b7ce514492dd43605e27b9276d210601f31a32624fe72af8c"
    sha256 sonoma:        "fbe60e713aca44e2adc2ae4d50f2d93f6053047a90820c3ae620e142916180b0"
    sha256 ventura:       "3f1f6158f5f07a5fce88a6c6497596da89c17fe438a761332921e4346c227f15"
    sha256 arm64_linux:   "97429c5667c198d2fdad6ad7545e278cef826f3e160117e6a9c172ad73cce69f"
    sha256 x86_64_linux:  "c36c64165586a9af662fa923e602821e649bee2a5fda5563c5de109e6429a9c1"
  end

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

    # Delete files that references to the Homebrew shims directory
    sb = nm/"node-datachannel/build"
    rm [
      sb/"CMakeFiles/CMakeConfigureLog.yaml",
      sb/"CMakeFiles/rules.ninja",
      sb/"CMakeFiles/#{Formula["cmake"].version}/CMakeCXXCompiler.cmake",
      sb/"CMakeFiles/#{Formula["cmake"].version}/CMakeCCompiler.cmake",
      sb/"_deps/libdatachannel-subbuild/CMakeLists.txt",
      sb/"_deps/libdatachannel-subbuild/libdatachannel-populate-prefix/tmp/libdatachannel-populate-gitclone.cmake",
      sb/"_deps/libdatachannel-subbuild/libdatachannel-populate-prefix/tmp/libdatachannel-populate-gitupdate.cmake",
      sb/"CMakeCache.txt",
    ]

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
