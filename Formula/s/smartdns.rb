class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "67adf2fbb005e6f0a1d933b0c115bedc4b5652379c50562808d424ce9b33a1a3"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b96963b9e21c1d8e21a9453411d50c42021d43d92fc8c5c6fb62cb10cb81545f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f75a1ff7ff80da5d5cace3ddf14c4f470b0988d9b1ef4f4b98a82bb4e1376a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efba197a233c72b8e82fb141c3b323a4f4f0a85d912949ed4d778136f409354e"
    sha256 cellar: :any_skip_relocation, sonoma:        "12892a189356ac7c064f4ab6b6f7ea374fc67d72e41fb436c86495bb8305ce21"
    sha256 cellar: :any_skip_relocation, ventura:       "a9e0814d983a9d3fa5fe0fe9d8732e9a0d1619196194c3546d2bcade63bb9de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed55429b36fc7e374336a2fb13c2bb7d43ba42658b6ef9e37cf43d897dbe8237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78ee95d4f63c25abe9e932b1e06d3df17f41f1d52d40ca030ca23a74b379ca2e"
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
