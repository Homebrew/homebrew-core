class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.13.tar.gz"
  sha256 "9e63fbeb4667c19e286389c370d30e9e904f4421784adcbe6cf4d6e172a2ac29"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b241ce4010f1d47941a32ba7d984a1fd9187d6e571f56c9997830c276915992c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e6e77d2503e39bb1c8eeeaf0379a0e6fe0549244d5a4401c540be07fc1d4e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3957e9143e2836e43a105260043c1a22292e698137a612270ca1060735ed5581"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed6f471d3f40a0882a056cf08639e99b2f4ceb5faeb1b5aed6dc029629b93cdb"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa0eb898f247bcb0b31f35f709de8009a81315bab443ae67ec84b50c33384ba"
    sha256 cellar: :any_skip_relocation, monterey:       "95ee65fce261c64ba0d0a5a6fa52da3ed6f546e667842f0becc2caf271d557cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf28032ee0cf55eac764d6813e39749fd7808b084b808b8caf291c5e4db3a66e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202405230041/geoip.dat"
    sha256 "0401b0a1b82ad0d01c119f311d7ae0e0bae4d928f287251df2a98281d173f3d7"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240508170917/dlc.dat"
    sha256 "25d6120b009498ac83ae723e9751a19ff545fac4800dad53ab6e2592c3407533"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.15.3/release/config/config.json"
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
