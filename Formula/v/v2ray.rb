class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.32.0.tar.gz"
  sha256 "537ee888deeaf2738e2124dfd12d74e1e62d7a7e8867fd90ac58e138e474da44"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3869220ecb29fe0025534285af00ba2f3b6e11deb9bb7067e33fcdeed9e48af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3869220ecb29fe0025534285af00ba2f3b6e11deb9bb7067e33fcdeed9e48af2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3869220ecb29fe0025534285af00ba2f3b6e11deb9bb7067e33fcdeed9e48af2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dfd86443c5a4b52c3066ac11b6c7016e99a0e4c5520125523817e4325a9c799"
    sha256 cellar: :any_skip_relocation, ventura:       "2dfd86443c5a4b52c3066ac11b6c7016e99a0e4c5520125523817e4325a9c799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b12100d1ed31a5d52ac167936b799731fee19a3d5e35bc0ae8caaca69bab837a"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202505050146/geoip.dat"
    sha256 "8023379316bca4713dcfa5ba4ea2fe7f4c127fff64a0cb7859d4756142b2c4dc"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202505050146/geoip-only-cn-private.dat"
    sha256 "f11dd802187c6630e35d7e40ce7879afb6f28413ece55fee68d95354b8cd4b41"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250523165307/dlc.dat"
    sha256 "b1d02c3b4f90830e8b4bda83a552da6d218407fe6833ddc8bb2c8b5372998c9f"
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
