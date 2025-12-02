class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.41.0.tar.gz"
  sha256 "c67caa2d73f35a9562ecaeb5184733c943c9dafb47e8f1cfeacb892a9247e9b5"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "719e2394b0475aac4e443ea5d018d8a221bc4f4bba68e1ed52e184f123a9c0c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "719e2394b0475aac4e443ea5d018d8a221bc4f4bba68e1ed52e184f123a9c0c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "719e2394b0475aac4e443ea5d018d8a221bc4f4bba68e1ed52e184f123a9c0c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1e2fd111799b674bb696db6f099837a359d0d3fcfb79c47460095d98a90ad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d486a59d1f4f59b3a3b209a23e7025b785ee86f0d8a7884dedb34937f2d99c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d96ca58e2a379c9912e5672b68ea709e4d28ec028d11adaed366e96f5135df8"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202510050144/geoip.dat"
    sha256 "c23ac8343e9796f8cc8b670c3aeb6df6d03d4e8914437a409961477f6b226098"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202510050144/geoip-only-cn-private.dat"
    sha256 "62a303deff40ce0d3735c2dc974b832f85b5f21892b03b0b4ae2acb53717d730"
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
