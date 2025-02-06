class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v25.1.30.tar.gz"
  sha256 "983ee395f085ed1b7fbe0152cb56a5b605a6f70a5645d427c7186c476f14894e"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f8bca0156ff99b6008190f998f23254deaf8b9951517a4e21fa88e83b8668bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f8bca0156ff99b6008190f998f23254deaf8b9951517a4e21fa88e83b8668bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f8bca0156ff99b6008190f998f23254deaf8b9951517a4e21fa88e83b8668bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff621798d320fa6bba481bfe5e8731613c6077f1e77c2ab27ab4c5e6929b80ce"
    sha256 cellar: :any_skip_relocation, ventura:       "ff621798d320fa6bba481bfe5e8731613c6077f1e77c2ab27ab4c5e6929b80ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b67fb6ffae7318c83e0ae54de251220cccc4741057fcc28e5f612325dd48879"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202501190004/geoip.dat"
    sha256 "4f8d16184b6938e635519bc91cb978dcea6884878e39f592f7144135401d6bb6"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250124154827/dlc.dat"
    sha256 "ac12d81edc6058b3c66ae96a0a26ca8281616d96ea86d0d77b2ceff34a3e1a9d"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.26.0/release/config/config.json"
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
    assert_predicate testpath/"log", :exist?
  end
end
