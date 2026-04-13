class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v26.3.27.tar.gz"
  sha256 "992a4997e6bb846d11469435d687f99ef812fcde1e0a009bb8e95189ea20331d"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff79bcf360802fa0aef96803a01bb46c4d52500c1b38263929f464b3c0fb907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff79bcf360802fa0aef96803a01bb46c4d52500c1b38263929f464b3c0fb907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bff79bcf360802fa0aef96803a01bb46c4d52500c1b38263929f464b3c0fb907"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd5204044d371e0ca845ca19f986a38e0e8407e37b4a7e90b5b56862eca24f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6d296df37d4a391985efce24056d66f557c60ff98f281691253b57de1aa05c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190c1acc90997a981bdd3a7219bbc0b95f9b10e3ac6ede1effd43c8f47ecc347"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202603282222/geoip.dat"
    sha256 "744c97b74c52bae2ac8664fef6ac481d7765cb8432a0df54f0368a88b9b4a354"
  end

  resource "geosite" do
    url "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202603282222/geosite.dat"
    sha256 "c202e5ed36a591ddd6d7b0164453d36c7c91a32be45e4d26256fd19d24c70b71"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.48.0/release/config/config.json"
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
      pkgshare.install "geosite.dat"
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
