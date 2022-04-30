class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "3f8d04fef82a922c83bab43cac6c86a76386cf195eb510ccf1cc175982693893"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ccca66b9ff941e7cb9e6fe047f718922c1999d0e5d9534b008973822265fa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c5ec82e93b037db86fb314147f4df94c21a4be7045be630bc98005aec3ceff3"
    sha256 cellar: :any_skip_relocation, monterey:       "d07d0ce3ec280a3ec60e6fcb58eae1c86d99cc49a1ce9b7e4e64ae489124de48"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bff6fdd20190ec7e1359835dd015979d500abc9b1426539c7390a7e371d48bd"
    sha256 cellar: :any_skip_relocation, catalina:       "57dda1f24bce56f94fc595daa273c464cb8d8e728dd51b652e712e9ae6c94dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e274206203fcae0629c63b0decf448333ad67d9975622f6fc14213108ff0243"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202204280105/geoip.dat"
    sha256 "38fe72a33f23920cf14e804bf14c26ea0210db3ea2108a2d51fa32c48ac53170"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20220429034939/dlc.dat"
    sha256 "32b0ebeb8d4c6b06584a7e14d1488c3628dce4ad7c7bad65a5af180513c311aa"
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
