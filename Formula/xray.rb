class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/v1.4.2.tar.gz"
  sha256 "565255d8c67b254f403d498b9152fa7bc097d649c50cb318d278c2be644e92cc"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "57de60b05b48e005338b6109a67d9ff37d26221b5e16d8564df800ddc01c5d4d"
    sha256 cellar: :any_skip_relocation, big_sur:       "578b31c235ca19f47fabb2cc0cf370f7876386f3e5a0cce19de48885c3656ced"
    sha256 cellar: :any_skip_relocation, catalina:      "c1dbfa4e54681f415f44a81045c8b82a48d81136f89ea8888fd4aaab6950274b"
    sha256 cellar: :any_skip_relocation, mojave:        "fba7e730baf36cfa04a4b1843faa45bdd66204a0e4c1a9ffb33be24f4718278a"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202104010913/geoip.dat"
    sha256 "f94e464f7f37e6f3c88c2aa5454ab02a4b840bc44c75c5001719a618916906cf"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210401091829/dlc.dat"
    sha256 "ee9778dc00b703905ca1f400ad13dd462eae52c5aee6465f0a7543b0232c9d08"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
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
