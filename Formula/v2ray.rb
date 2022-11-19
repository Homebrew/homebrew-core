class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.45.2.tar.gz"
  sha256 "7a126bac7df32f627f34331778cb39ac99db18d7edcd45628db06e123fa0694b"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "950f263eca43e38d68a850bcc97e1a2e3fa41487c74a983a176aee50c973649a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39375e667ddca5e5d93f0c399d8969be3f0ca8015f8179c6dfc9ecfa1aa2222c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f743a933cca4e588c3f8ce883aa62944be19360e330b6d55f559eb1b72bb4f6"
    sha256 cellar: :any_skip_relocation, ventura:        "1aaafc337a929402bc1ba5b10196da7ba5909151c188afbd328cd3927136cfe0"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca8683200055af0e1d7895b44aad91ac1f47ad2abe42a73bf3da2a59db714e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ac146769d892d242d4bd2c15c1630653ad85e0ac6d36d111aa03517be3a5be"
    sha256 cellar: :any_skip_relocation, catalina:       "39ad8bcc96f63ca58873ec903c3974dcfdf5c6c9b38fc1f3cd1e787e2da57330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a9d347cd01bddb5e1a4c81c0374b4c6ca62b5ea3f1f4e353c1c68f59895089d"
  end

  # Bump to Go 1.18 with when v5 releases.
  depends_on "go@1.17" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202204280105/geoip.dat"
    sha256 "38fe72a33f23920cf14e804bf14c26ea0210db3ea2108a2d51fa32c48ac53170"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202204280105/geoip-only-cn-private.dat"
    sha256 "e8d0d7469b90e718f3b5cba033fec902dd05fab44c28c779a443e4c1f8aa0bf2"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20220501162639/dlc.dat"
    sha256 "dff924231ec74dd51d28177e57bc4fd918f212d993a6c1264f335e966ceb5aa9"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"
    (bin/"v2ray").write_env_script execpath,
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
    run [bin/"v2ray", "-config", etc/"v2ray/config.json"]
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
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
