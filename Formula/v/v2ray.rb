class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v5.7.0.tar.gz"
  sha256 "599fcd264537e39178b6008a11af68816dfd1609e19a9cf8adc8b2a4240ee370"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  revision 1
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38e84f1f30b5835c66cf81834003afdce126f387b9281a4f93165a70863c8ebb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38e84f1f30b5835c66cf81834003afdce126f387b9281a4f93165a70863c8ebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38e84f1f30b5835c66cf81834003afdce126f387b9281a4f93165a70863c8ebb"
    sha256 cellar: :any_skip_relocation, ventura:        "16cc7dca1bef1c45ee9989d57c9097fb1bce97f4f75ba854c39628fea6c20ad9"
    sha256 cellar: :any_skip_relocation, monterey:       "16cc7dca1bef1c45ee9989d57c9097fb1bce97f4f75ba854c39628fea6c20ad9"
    sha256 cellar: :any_skip_relocation, big_sur:        "16cc7dca1bef1c45ee9989d57c9097fb1bce97f4f75ba854c39628fea6c20ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c09457ba4832a2d44e7bf70be876b04d5de9a4f49bb7a2ac135d96fa86c8a9e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202307060057/geoip.dat"
    sha256 "a200767fcf152a4886c8bbfc8e9b8325cb405dd8076f911a7d49edb3ddf20024"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202307060057/geoip-only-cn-private.dat"
    sha256 "6794c150eac1bb8727dc9c3ffb6cc576374ca2b6ec262f8d742007c96966ddc7"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20230711133630/dlc.dat"
    sha256 "bcbad43679badb8eb383f63ed753732d0378042c42199b17edcdfedba6d458b0"
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
