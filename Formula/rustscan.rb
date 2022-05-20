class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/2.1.0.tar.gz"
  sha256 "10958957148544da780c1be4004b906e94bafe02a19f0224f6026828fb77a8cc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b0c49e379f4a26ce81c5efb99befcf90fef1415b03c85105a9f119aab8b6273"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40dfd5fafb1b91e5b98866ade1562aa44b2d1b9ec10183bdd49d4b771c596d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "b92354edb90c2ee5414c003d0d430a8800fdf9925592b72578c500ab50587694"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8f2ecf1e087109d362dc6cf649ebeeacdc4aee3c8f4c32ee0920e825695af68"
    sha256 cellar: :any_skip_relocation, catalina:       "a1f7ef6167f4f2756ae5418447773ef610fe8961a8e57f8576d308c9589d7bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4713f24aa727940fad2bf26127cfef0267130356a99ceac50459b1674a06bd5f"
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    refute_match("panic", shell_output("#{bin}/rustscan --greppable -a 127.0.0.1"))
    refute_match("panic", shell_output("#{bin}/rustscan --greppable -a 0.0.0.0"))
  end
end
