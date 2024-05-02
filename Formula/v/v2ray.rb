class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.15.3.tar.gz"
  sha256 "32b325e54ee93fb3563c33d3c097592aa857370055d8ef1c50fd2387678843df"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6905533fcab6f69a8d4ce2e0d1f0513fd67ac8e32a5e74bbfb1e12c937b00e29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eb9c75ea0a613dc408c0f3c1875dbc7755afc5b083b37f45f7bada2e9c5befc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86236fa9ee548e18c09e5a08c1d3bea04e54416d4c4d5429f9078162a1cf490c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1592e6ce6b5b4a9aed6d3b34459e483c93d5f29a9f3637360b4bc258b08f2894"
    sha256 cellar: :any_skip_relocation, ventura:        "e94b6df33437512342176962c3a55f4d4b67f26b5489bd164ebf0143c66296fa"
    sha256 cellar: :any_skip_relocation, monterey:       "7b705c65cb7b8ba5cf707efbac04e07f8b428f790492127f058eb72234f56bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bd17be0872440c10491d1973db7750edfaa85c21693b1a21c8221906fd95809"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202404180039/geoip.dat"
    sha256 "a0ba7f1aa6fc85c20d6e17c4696cee28bc45784cf2b04c2891f8b6f2eb653d9a"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202404180039/geoip-only-cn-private.dat"
    sha256 "156b2c15660f8f8f2d1bc83522cf921603ed8456db3bf671d802111b207f8b9e"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240422085908/dlc.dat"
    sha256 "18b5b7f44471d27781a53933bd71e2d9fddf5549c06003aadfda8afca3c3eb1e"
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
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
