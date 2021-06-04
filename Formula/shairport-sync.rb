class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.8.tar.gz"
  sha256 "c92f9a2d86dd1138673abc66e0010c94412ad6a46da8f36c3d538f4fa6b9faca"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "69aca6973958639950c913bc230b93bf23f200ca4ad4031a2e23f400ae9d9468"
    sha256 big_sur:       "d789905a7d6a4c93b28b5a5ed07d6b1b5a32ccecdf47c41268525404d406dcb2"
    sha256 catalina:      "1e284d58843c0bb34a421bb5259b3e81759c77eecd992b0f9e4b66976155bb55"
    sha256 mojave:        "202eeb58dfed5376c7be58ed53eab101ee9d829d142e374056984db25ce77aa0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os=darwin
      --with-libdaemon
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-stdout
      --with-pa
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options manual: "shairport-sync"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/shairport-sync</string>
          <string>--use-stderr</string>
          <string>--verbose</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{name}.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/#{name}.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
  end
end
