class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/v1.3.1.tar.gz"
  sha256 "5b860144c470c3f7c6b71ffdf0c3830980f1f6ce431fbe6bf10249c1f0e991a7"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9765e7df071e456ea09873a40530b6d4ee8333079e54b068c8673d58984e27e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb471e2bc6dd18290c0e8011a28dc1d63d2ef615b661f2dca2d8820f9ed782be"
    sha256 cellar: :any_skip_relocation, catalina:      "f357ebc653a5c6a87d29526f8d03fb3fd31f936b78a3d0bb1f3e80bf53564876"
    sha256 cellar: :any_skip_relocation, mojave:        "ff1bd3ebc1b39a1f513cf9bf6e71488190557b503c5f3ddc5551d450aa5d6163"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202103040019/geoip.dat"
    sha256 "b2b2804ae07ec87c5df9473d5d547688461425ab50e3f58d4585ac9c472629a1"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210304030907/dlc.dat"
    sha256 "e38a086c5384eafe5b0423e4abafa51d6b05f1862e808eea88d9bcf808fd3467"
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
