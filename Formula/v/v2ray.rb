class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.39.0.tar.gz"
  sha256 "a6f6db8a6911dbaaf9c140a73e9f9d56706e046bf2cf234da3d06bb4ee4310a6"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d12ab219984438a2f801a98fb95939bed2698e32c45c1b5a317ce43b56c250d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d12ab219984438a2f801a98fb95939bed2698e32c45c1b5a317ce43b56c250d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d12ab219984438a2f801a98fb95939bed2698e32c45c1b5a317ce43b56c250d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb400990c3219c2811d71c7f994146195662ef642d98aa21b343665663c2a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9fac4a09ae0e9abd0c773de9d3e4c303b361d126566b0ae7956052035b5be19"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202509050142/geoip.dat"
    sha256 "a01e09150b456cb2f3819d29d6e6c34572420aaee3ff9ef23977c4e9596c20ec"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202509050142/geoip-only-cn-private.dat"
    sha256 "845483083b4a7a82087d4293e8a190239ae79698012c1a973baac1156f91c4c2"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250916122507/dlc.dat"
    sha256 "1a7dad0ceaaf1f6d12fef585576789699bd1c6ea014c887c04b94cb9609350e9"
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
