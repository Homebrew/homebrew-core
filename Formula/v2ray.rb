class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.45.0.tar.gz"
  sha256 "fb8731295d8bbad9ef9157dbd3bc62655752d36544e0cc4077d4fa8a8a4ea295"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed35ca9af1b8676f23c13c634b0d90adf7dd64d71447d336691ea103c5335eff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "525ca0430ea28dfe431e95f37d8068bb2f8d8f10a9a6feb3eaf883cc71c4bd04"
    sha256 cellar: :any_skip_relocation, monterey:       "70af4156221e1bc7fccdce3e9ac05fdb80eb8ee5149e81a507207fceb23d529a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9aee6f3becb85153af3fa3ac37e82ab3e2dac66390551841fabe777116950df"
    sha256 cellar: :any_skip_relocation, catalina:       "193dcccc183edfa7a5aa54e28dbdb4e93986e65671a8faa0930c72d3f57ded9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3525fd22ab391059ed786f2baf7fb58d435f5381a4ecc60758d8c78b79e5be44"
  end

  # Bump to Go 1.18 with when v5 releases.
  depends_on "go@1.17" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202204280105/geoip.dat"
    sha256 "38fe72a33f23920cf14e804bf14c26ea0210db3ea2108a2d51fa32c48ac53170"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202204280105/geoip-only-cn-private.dat"
    sha256 "e8d0d7469b90e718f3b5cba033fec902dd05fab44c28c779a443e4c1f8aa0bf2"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20220501162639/dlc.dat"
    sha256 "dff924231ec74dd51d28177e57bc4fd918f212d993a6c1264f335e966ceb5aa9"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"
    (bin/"v2ray").write_env_script execpath,
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [bin/"v2ray", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
