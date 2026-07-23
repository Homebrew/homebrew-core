class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.51.2.tar.gz"
  sha256 "7316dd294af15b9c92ba7db09fb274aacec919d18e45a594305c8d8b020bcb50"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59842e0ad329399214231d391dcbe353bc12a708657900eb456788acecbc7bbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59842e0ad329399214231d391dcbe353bc12a708657900eb456788acecbc7bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59842e0ad329399214231d391dcbe353bc12a708657900eb456788acecbc7bbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "137944c81742a9c205b7964ccac565d060c21f09c0c810eb32306866c37de987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33f5ab5b73af7cade6881fc61a207a2900e99052cd41226674a7cf14c8bd5ccd"
    sha256 cellar: :any,                 x86_64_linux:  "49a99d1cfd49d3bcf8faa49b4f685e6dfb2649a12c43106d37f422842345f407"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202607050337/geoip.dat"
    sha256 "b71d1999439dde2de2d2b6844a2befa50c50211ff739785c005ca7c230a17d6a"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202607050337/geoip-only-cn-private.dat"
    sha256 "dff2733e43dbbdae88b2a59f908572eb5d9267d4afdb4c456a17f4a49d36747f"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260706034657/dlc.dat"
    sha256 "79259090bb43e906a74fcb59b7e4b4afc83e8238a0d75f15f55f5f71e62671e9"
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
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
