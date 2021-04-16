class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/v1.4.2.tar.gz"
  sha256 "565255d8c67b254f403d498b9152fa7bc097d649c50cb318d278c2be644e92cc"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49099e603dd66c25dcfd250e87559841abff25a96f48a96ec787c139aa47d06c"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d98fb0997a94df4d413003bd95f5821eb6fbe293e5efa85b205e8e5e5bc0147"
    sha256 cellar: :any_skip_relocation, catalina:      "130b05c879ef762488846945ec42e8e5ffb73d67d82917eaf7e3bfcf56032481"
    sha256 cellar: :any_skip_relocation, mojave:        "f68a2892b2be3a4f97c1fc2ec02be2a0a00fb884c8eeac9621330d33683bde1b"
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
