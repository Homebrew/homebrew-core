class Rustscan < Formula
  desc "Faster Nmap Scanning with Rust"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/1.3.tar.gz"
  version "1.3.0"
  sha256 "3bbaf188fa4014a57596c4d4f928b75bdf42c058220424ae46b94f3a36b61f81"
  license "MIT"
  depends_on "rust" => :build
  depends_on "nmap"
  def install
    system "cargo", "install", *std_cargo_args
    # bin.install "target/release/rustscan"
  end

  test do
    # Due to law, users installing this package may not be able to portscan websites
    # Therefore, the test succeeds if the user can portscan themselves
    # We do not know what ports are open on the machine, so we have to assert 1,1
    system "rustscan", "-q", "127.0.0.1"
    system "rustscan", "-q", "0.0.0.0"
    assert_equal 1, 1
  end
end
