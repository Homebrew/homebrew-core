class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v26.1.13.tar.gz"
  sha256 "c814c9b2e6c92e08d3db929792c56e2863a1a0e252c774ec048095efea6b67a1"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c0f4e4e295d87da14b03ce1e51403635758303ab046f5a40e9891080a8a1e50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0f4e4e295d87da14b03ce1e51403635758303ab046f5a40e9891080a8a1e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0f4e4e295d87da14b03ce1e51403635758303ab046f5a40e9891080a8a1e50"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a13c59867a4f9389dae519de92d8a893df16e4bc23a06a00c591d5e2a2614a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86bc68f7348a1eaae973307ead7cd9002c1f3d84f311e04c4afaa6c5e4810281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67998b49127e430df4e2d86d01884e47ae770519d07ab0db45d408e459b7738a"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202601050204/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260113123549/dlc.dat"
    sha256 "6ef1e466e7f672a3c49dcd1378b96c8bf38334024252d4a00b1e725df389558d"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.42.0/release/config/config.json"
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
