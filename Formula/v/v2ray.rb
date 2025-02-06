class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.26.0.tar.gz"
  sha256 "81fcb688a576c0a15a96e0300244274ee3c9f08fbc7da36e542b4f51b6d2725d"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d837ca658c727b583e2cf61603979b4ceee5726bad7c180dbba587189a65353d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d837ca658c727b583e2cf61603979b4ceee5726bad7c180dbba587189a65353d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d837ca658c727b583e2cf61603979b4ceee5726bad7c180dbba587189a65353d"
    sha256 cellar: :any_skip_relocation, sonoma:        "20f1078905b5f9a245cdad21857f74e4af2e874ce9678565d476a29837cb1a86"
    sha256 cellar: :any_skip_relocation, ventura:       "20f1078905b5f9a245cdad21857f74e4af2e874ce9678565d476a29837cb1a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb4b341e67734517ef7ca1d291c36bf3e322b382cacbc1adc864b6299a71817"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202501190004/geoip.dat"
    sha256 "4f8d16184b6938e635519bc91cb978dcea6884878e39f592f7144135401d6bb6"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202501190004/geoip-only-cn-private.dat"
    sha256 "96d09ba875524044156e33406e72638523c7152377c10d1994028475462b173f"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20241221105938/dlc.dat"
    sha256 "aa65cee72dd6afbf9dd4c474b4ff28ceb063f6abf99249a084091adb4f282f09"
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
    assert_predicate testpath/"log", :exist?
  end
end
