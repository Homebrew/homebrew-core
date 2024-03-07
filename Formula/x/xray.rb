class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "156105b89465ca948971a774c0bc7e56ee68e764bdfde58923037dc837aab4be"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de4fe88756639bc048534b22d7821057cbacf1352b8d93e324c9e485b93f8c2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "081091b87d7dee139a6b88bfee635d0768ccbabcadebcce972d8c420ce406770"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24e0aedb78e98dec5fd3655427af4a5c9244c036980ddce9076d3732965f6a62"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5b7d679b042b85a9de309f49fc0cc8e3d7b5637acfed0231d275c42389ee8b5"
    sha256 cellar: :any_skip_relocation, ventura:        "23f1673d53a455df109b2b2dbdb86dd5e4fccc62ec65dc8feb66deed40f966db"
    sha256 cellar: :any_skip_relocation, monterey:       "283530a13ed5380f8d602aa2a4260a62583527d5724bf670ba2451faf4493bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33545b1fd88d294850fdb8b58977eab8683f4b80e74466d6b492fba77af1781f"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202401110041/geoip.dat"
    sha256 "37ec29d3aec3d22a575da7d6e858e22a492eafb8abc34a0b288d353acf6ee1a2"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240105034708/dlc.dat"
    sha256 "9f833c47b103fb475a68d3b0f5db99d7b7c31dd9deab9171781420db10751641"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.13.0/release/config/config.json"
    sha256 "1bbadc5e1dfaa49935005e8b478b3ca49c519b66d3a3aee0b099730d05589978"
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
