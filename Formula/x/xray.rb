class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v25.9.11.tar.gz"
  sha256 "9bccd2681183698bf860b1af5407f97b4b60090324aa3ef1546e446612d44e1f"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6ea44f44b4e191b0b92f492ee0b32c2e9883d46c57e165a0b03f7f14a7d22ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae072697abe3cbfe40ebfe6c0b766d2d5bb8b789389a88b678a3ce9d05a6ed63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae072697abe3cbfe40ebfe6c0b766d2d5bb8b789389a88b678a3ce9d05a6ed63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae072697abe3cbfe40ebfe6c0b766d2d5bb8b789389a88b678a3ce9d05a6ed63"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ede56078ad6f89ce8536e38e12ec6729aa6d750624585b8788fbb34d15f1bb8"
    sha256 cellar: :any_skip_relocation, ventura:       "3ede56078ad6f89ce8536e38e12ec6729aa6d750624585b8788fbb34d15f1bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad89d5433512f712d169d08bde964a220e0c1ea827f98afa9fb96a91d45d6912"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202509050142/geoip.dat"
    sha256 "a01e09150b456cb2f3819d29d6e6c34572420aaee3ff9ef23977c4e9596c20ec"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250906011216/dlc.dat"
    sha256 "186158b6c2f67ac59e184ed997ebebcef31938be9874eb8a7d5e3854187f4e8d"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.38.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags:), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/xray/config.json
    EOS
  end

  service do
    run [opt_bin/"xray", "run", "--config", "#{etc}/xray/config.json"]
    run_type :immediate
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
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
