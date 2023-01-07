class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "e35824e19e8acc06296ce6bfa78a14a6f3ee8f42a965f7762b7056b506457a29"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7942546d2fce3c1f5eb04cd27fa30d884a4b5d1f336978a28212e8a6452b683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce0b4bdff2e2b4e2b8d9fd40e486e84d9c046ec3f7c9a5937c65382b86d5fdf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "778e1bef5150829f42ff37c0dee11c321d2a5097bd43c50ca7f9dc8acda43c82"
    sha256 cellar: :any_skip_relocation, ventura:        "e5a6436263aaf5126dd19001fdb11ee1963bb4e3bbce733dc8bc9f5134d7975a"
    sha256 cellar: :any_skip_relocation, monterey:       "e806f0211ad001393c6a83cf3004fe77e9fcb3e7a27cca76c9e2aacee58907fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8a1de369151ae79b029283b08779a7e487189d292e13499b029ab4c51bf5d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "884d8b45e867e82fbcc4cf0ef5323303f5ce3be807d567135becd56a8c1713bd"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202212290044/geoip.dat"
    sha256 "da84c95fcc09bdb60334cf4ff0d26e6ff1c3d7906a9c5c91d69556a425558677"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20221230094252/dlc.dat"
    sha256 "ed244308475f880a06a02ebd7872790bb32704ca3bdc7c79070aa35f496080e0"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v4.44.0/release/config/config.json"
    sha256 "1bbadc5e1dfaa49935005e8b478b3ca49c519b66d3a3aee0b099730d05589978"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags: ldflags), "./main"
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
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
