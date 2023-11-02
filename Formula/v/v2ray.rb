class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.10.1.tar.gz"
  sha256 "dfa0f9d6d1297819567cedad525025d2a6db07a1553213f2ecb2de110918c07c"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4da0226245574f82f2a8e1f9e16856b9bf2e540cd3a95c196dd3ca071f940b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d12a591f1940ed6edb99ebb2df6670216c7ce023730c9e6da450b88f19aa55c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91738748b76b9a5d6a74585f52413cc5ad906e3b1de08e28912e7935ca78ca8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb5ce16123699efd002f0b2e5f281c868e415fb8f85a16d426a7f61991ea821e"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd63eaabd098a0fb1d673f93b0bd8814fe475b03bc7b076139c0e5d9ce7dccc"
    sha256 cellar: :any_skip_relocation, monterey:       "02c90b8ec61f61e2851495b209e51eb2a70339855308e4eb2de40377554ef987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b6d3427246ed3f08f99478d439a37b5952e4f4a9cc819a164ba13d1330fbe32"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202310260037/geoip.dat"
    sha256 "f24e09d29ffadb75d5eb41483b4eddfe139b9b448886dd2bcdeb2df2c0dcca24"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202310260037/geoip-only-cn-private.dat"
    sha256 "23dbef7227bede25fddcddd5a2f235fd33ef01e760d3dc3354d6f2cf21f223d3"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20231031055637/dlc.dat"
    sha256 "6053d81679c4b4728ed5841d12235ce8073c806f49afed212b75b11bfdbbd489"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec/"v2ray"), "./main"

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
