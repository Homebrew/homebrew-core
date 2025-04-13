class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.29.3.tar.gz"
  sha256 "f2a2eb4c835a99339746eaadbb1c88b4dcd022aa6d801ca44936be36f3ed027a"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b61018b8c72f094191a95284410329d9583226691fa9abc3bb3a8120a61bfdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b61018b8c72f094191a95284410329d9583226691fa9abc3bb3a8120a61bfdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b61018b8c72f094191a95284410329d9583226691fa9abc3bb3a8120a61bfdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "efc5b82f8a5d76593ba2ed8e7600fe29aef3cc4082c96d98a4cd384121cc8d4a"
    sha256 cellar: :any_skip_relocation, ventura:       "efc5b82f8a5d76593ba2ed8e7600fe29aef3cc4082c96d98a4cd384121cc8d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f63f80c81e91b5bf4457383eb419442fcc71523a2c72fd059ed4dd05d4e390"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202503281421/geoip.dat"
    sha256 "83337c712b04d8c16351cf5a5394eae5cb9cfa257fb4773485945dce65dcea76"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202503281421/geoip-only-cn-private.dat"
    sha256 "8b68721aed2ce55109c907d5c080f4e6b8ba8392b5dece4e4561ec9b2b40e512"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250329145339/dlc.dat"
    sha256 "d0f0e5c954f65775d1f5b34a813a64cb8868ad61a78ea183386d5bf84b3c8fca"
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
