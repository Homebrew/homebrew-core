class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/1.10.0.tar.gz"
  sha256 "63c387c645826107734eb10d45b0a540a69fb3a61e478593f515adce95bad530"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f6072b555545a3efe33cc84aec3ba11c8110b038fe51cd1ec95be921e44fe16" => :catalina
    sha256 "29b494ff1b888b9cd2e94a61168236ccab5a2030a923efc490706301dcfe7bef" => :mojave
    sha256 "03b01fce247218e8dd5e60565199c61e4d458ab0d66f9952a2bbf158d04c9f0f" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_no_match /panic/, shell_output("#{bin}/rustscan --greppable 127.0.0.1")
    assert_no_match /panic/, shell_output("#{bin}/rustscan --greppable 0.0.0.0")
  end
end
