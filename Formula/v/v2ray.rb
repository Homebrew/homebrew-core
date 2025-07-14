class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.37.0.tar.gz"
  sha256 "a8aeab23fe4dbdf2236fb7ecdeb451d92f76eb7d652628b18a1e4a219baa003d"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b10547fe184e3cb1176bf6dc3161f8bad72750412d8223bbc553c38da22c798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b10547fe184e3cb1176bf6dc3161f8bad72750412d8223bbc553c38da22c798"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b10547fe184e3cb1176bf6dc3161f8bad72750412d8223bbc553c38da22c798"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d85970d7dfcb9864b0dfb539625aa7d486103debf5d2d96b4feb82610875736"
    sha256 cellar: :any_skip_relocation, ventura:       "1d85970d7dfcb9864b0dfb539625aa7d486103debf5d2d96b4feb82610875736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa6611d1ffcffef88e706304f93152b58a90b9f95d89a8c4ff27cda4a6b6ef2e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202506050146/geoip.dat"
    sha256 "58bf8f086473cad7df77f032815eb8d96bbd4a1aaef84c4f7da18cf1a3bb947a"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202506050146/geoip-only-cn-private.dat"
    sha256 "1cc820dfe0c434f05fd92b8d9c2c41040c23c2bfe5847b573c8745c990d5bc98"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250627153051/dlc.dat"
    sha256 "01dae2a9c31b5c74ba7e54d8d51e0060688ed22da493eaf09f6eeeec89db395e"
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
