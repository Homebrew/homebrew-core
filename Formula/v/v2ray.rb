class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.20.0.tar.gz"
  sha256 "2de8ac3429705f594ca1a75a2a0fca09820938c94e912370902f87bd72680693"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef0bd11efaa0565b2909864d7f6937f71d0dd2d2c4aa4ef1a08a1fd8896a2cc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0bd11efaa0565b2909864d7f6937f71d0dd2d2c4aa4ef1a08a1fd8896a2cc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef0bd11efaa0565b2909864d7f6937f71d0dd2d2c4aa4ef1a08a1fd8896a2cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa50bf190698771c2bfd5e34cc8c9d364458b6a4be7c0c8a17621a4ca080296e"
    sha256 cellar: :any_skip_relocation, ventura:       "aa50bf190698771c2bfd5e34cc8c9d364458b6a4be7c0c8a17621a4ca080296e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0672538ee975aeec9c7cb4af468624384cfc9d201aa4ad4fff617badb0a394a8"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202410100052/geoip.dat"
    sha256 "384c0143e551dae3022b78d9e42e7d3c9c9df428710467598c258312333c88ff"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202410100052/geoip-only-cn-private.dat"
    sha256 "56a5649fb701aeea0adb9ce29163b4ec75f9c60853e44ffc5cf6450664e41e16"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20241007202930/dlc.dat"
    sha256 "03a097fe913113941878898cde9d48f3c89f7b8f3c493631fcff354ed845f1d3"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
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
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
