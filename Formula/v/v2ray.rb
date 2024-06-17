class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.16.1.tar.gz"
  sha256 "e5d61b97168ebdf6da3d672ab40abe5b22951d46997072ca1ee497a3aa47ba05"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57fe134fc62d02de5f3d973a665c2fa591ce3ff07ad790fdb8c6aab6d6340479"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e1e64b741d5f6e452eed6b4b9fd19e4a9c0e05158e2b1054e2fcc6a799f04f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1df1e4ab9be9949b276c67f5540bc7638bc7d224aa8bd3ed511a9fe952f16ac6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccd21045c642fee45bad9da2f11abe64ebd47e2419757f73de6d55f83c827ca7"
    sha256 cellar: :any_skip_relocation, ventura:        "b361f6897a76d3eb93dc28f92e0145159dd651027aaf8b8f2b14ea0d241f4e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d2b88bb5d11833a745cf0347c3a1653156e11ab4f4b2778c13f5697a149b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bcaff26641b658998fe07b3d62ce4e55bd9fc5c557d6931ad95c0228d64e7fb"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202404180039/geoip.dat"
    sha256 "a0ba7f1aa6fc85c20d6e17c4696cee28bc45784cf2b04c2891f8b6f2eb653d9a"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202404180039/geoip-only-cn-private.dat"
    sha256 "156b2c15660f8f8f2d1bc83522cf921603ed8456db3bf671d802111b207f8b9e"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240422085908/dlc.dat"
    sha256 "18b5b7f44471d27781a53933bd71e2d9fddf5549c06003aadfda8afca3c3eb1e"
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
