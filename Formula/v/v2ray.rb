class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.44.1.tar.gz"
  sha256 "b11d6ff12e69e1cc21e18e4eb6da2fb6332fa6a6cca53fb1a3f42e2484e0ebf3"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "425f3b5f3ca1f653e2d3fd258818c4594bf86ec8503150e187ac9ae5077d38ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425f3b5f3ca1f653e2d3fd258818c4594bf86ec8503150e187ac9ae5077d38ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425f3b5f3ca1f653e2d3fd258818c4594bf86ec8503150e187ac9ae5077d38ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "94d505a6fa0d44b125ff6591f05b3b30c716dbb39f3376595f318099b5ce621d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24c033643be2d055a4447a4b21822c59dec1e3ec32a013c4a7e03f2c5b0d61a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7406404b69b61b21176e77607ea9142b8e9b16c8b2504f41ce636d8e76a58c2b"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202601050204/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202601050204/geoip-only-cn-private.dat"
    sha256 "41d23732ab1b4b08326c356c63656aac3727f1eed5d5828d7ceafe7dbb121662"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260115051358/dlc.dat"
    sha256 "f90a40e8e499036f408a62160fbc1c8eecf87ef81cc456f094ab728da5a6f586"
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
