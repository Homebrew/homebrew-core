class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "120b6c750cb8fb063ddbc7de42458c6a3e4b7cfdc2650914022bddc324a75894"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "639c0b5b272a34fd146b6511353ab1fd5a961718e0bbc7542b0cb24873c5cd34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07a72f096a91617f4c87a297c35fed403a7f03c949e9184c341641d3bb44b52e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b1950dcad30bacc672e60747b93b1cb8879e79f08ebadfc6411a070bc313147"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad7944e95a74bffdbab5320c379967f525f7197b40501002f9c8db523072a1f5"
    sha256 cellar: :any_skip_relocation, ventura:       "408b520be64c4eebd59e9110e75e7c271e198f70d22b3d393f5880559c311dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "294abaf73ccf0ded6bcfd3c9e0d848a71521ba6df05934f95450b54d7b497053"
  end

  depends_on "just" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3" => :build # cargo patch
    depends_on "pkgconf" => :build # cargo patch
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "just", "install", "--no-default-features", "--features", "homebrew", *std_cargo_args
    sbin.install bin/"smartdns"
    pkgetc.install "etc/smartdns/smartdns.conf"
  end

  service do
    run [opt_sbin/"smartdns", "run", "-c", etc/"smartdns/smartdns.conf"]
    keep_alive true
    require_root true
  end

  test do
    port = free_port

    (testpath/"smartdns.conf").write <<~EOS
      bind 127.0.0.1:#{port}
      server 8.8.8.8
      local-ttl 3
      address /example.com/1.2.3.4
    EOS
    spawn sbin/"smartdns", "run", "-c", testpath/"smartdns.conf"
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end
