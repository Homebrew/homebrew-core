class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "708cf7754c733c8eb98939495c0c2e698ca5712383b87dc25eea974a0d332721"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4d1774a15c73ef43a048b3140bd13de772c113d7779d8afd1dffdf54054393a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1272dcc8684383182fb458ade5355d793acf7eadaa4b1a779ea8fa03c18a3e06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ff7ac062293fbdddcae1c079040d3797e72b9db9e484c928a623240570269a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f5e3f22ed5590503011832cda0c9e8766b468fd3e5f071a0eaedf4ced4cfeba"
    sha256 cellar: :any_skip_relocation, ventura:        "4af211f2b3117abb2dcc7bcdbd86c4c0d07eeda6fb3523fe3de8bc00adeda17e"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1905a9a53832eac4c6ce5cc74fb56851aefe2c2a61cd9c0dad1694d70d8282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e0c95912afd666b6adeae1b27e53c9464997f307ee2bf90a9ad6aaf02ddfc39"
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
