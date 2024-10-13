class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "80048b1d07e5b009eae0ab42e9192ee39a92a9694011b4ceeac4be2a5a41114e"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b863eb708ca47f00e07e0ecf9afd7510d6b83fe6386518dccd9fb4e862219c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50e8e9587095af5017693baf8698b8bd8c3d6f9a0ceaaea9d59c141c03a73b89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c94498c25a5687d2195c8e33c6f6319eef6de750717225f31d191ac9ec06029"
    sha256 cellar: :any_skip_relocation, sonoma:        "c341f38b3d70ee1ac61f49baf9c291eecf75cf3da120c72c642e98a35c9a42e1"
    sha256 cellar: :any_skip_relocation, ventura:       "35d074ac44f263881052fcee729a4e6133a34eded9580d742fc1ce7b804631d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4938ab6f8fc7a5c0351de6b5f6e1ddde636a0336b214b011e96905a2d4b3b30"
  end

  depends_on "just" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3" =>  :build # cargo patch
    depends_on "pkg-config" => :build # cargo patch
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
    fork do
      exec sbin/"smartdns", "run", "-c", testpath/"smartdns.conf"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end
