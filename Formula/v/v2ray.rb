class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.48.0.tar.gz"
  sha256 "7900d9ec61014c1b87c149e43aa4f3b03be4bc756cbfe9a75926d5a7ac86105e"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc966de896b1bae6e6bc072f17d57dcecda6f53cfec9e4c19fe7b7fe7aa2978c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc966de896b1bae6e6bc072f17d57dcecda6f53cfec9e4c19fe7b7fe7aa2978c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc966de896b1bae6e6bc072f17d57dcecda6f53cfec9e4c19fe7b7fe7aa2978c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e30e9d2eb78048e8d016cbc681455ed8087d75e2f89978931eda43bf2badc450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74885192d94fc66a8f16afd56323323245bf31f39755d6f6539aa338a45ea8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bebf9bd3b2eb2e561ecd3858dcd510fc0d8a63ccf013cb261cf34ef9d2b288c1"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202604050243/geoip.dat"
    sha256 "16dbd19ff8dddb69960f313a3b0c0623cae82dc9725687110c28740226d3b285"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202604050243/geoip-only-cn-private.dat"
    sha256 "be508bdc4b760a3b3a1ea3683f7746691adf13757b77548f1fbe9dc6c26b2220"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260412150845/dlc.dat"
    sha256 "494a7f1a2b18fcb2fcfb65628c3fc7b40ca4afe84283edd7d03fbbeddcad01f2"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
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
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~JSON
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
    JSON
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
