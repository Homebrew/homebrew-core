class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v26.2.6.tar.gz"
  sha256 "a41f170a03fa25d9d39f23f344540b02336a5c893d97b1b837b9477f4b35bc7f"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92da454b89199aa6c48c76e1c003342bb513af7b962cf7ab428dff5458b91ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92da454b89199aa6c48c76e1c003342bb513af7b962cf7ab428dff5458b91ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92da454b89199aa6c48c76e1c003342bb513af7b962cf7ab428dff5458b91ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d12bc1f05523bb07d1599a56fd84babea5ad6a0b5b2d8248af1cd79a67257c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42fb5b479fbe65b4226e5131556ab6c91b72399d2848d23339960216b85462ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a79f11956710dff040c0560e8b7a462dffd34232ed25f857b825a374db53eea7"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202601220433/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260203145437/dlc.dat"
    sha256 "158e0e3052238dcdd09d58857032c67da49b933b3a9fd74fedf2c684e21d4f87"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.44.1/release/config/config.json"
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
