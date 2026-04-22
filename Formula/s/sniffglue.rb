class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "54d98ebf5cf947f9d833fbb0457f6b5ccd7e96f356bc4cfdd1711a3526e785bc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab915b01590ea26dea46acf68837eb664a37c9e337baaec569f62bc20e6ed831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7840aa9f1f1502861724660bb225c7dc26a732e285b1b18d05fa6885485d200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb9cde1c9761af50d50c22aa20d961a46b0f2fbd712eb4de52449344e62d7875"
    sha256 cellar: :any_skip_relocation, sonoma:        "3184c2a0a537be7be59964355aab93b4572466b75c2e4ec5081a5baae6abc02e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e277bca75e8ebed4e47c23168ecd19cad9f78ff5d581dac6d67f87f6db21f4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190d1e3f26259cf4cda05932b8077aa03b3d352e8e67ef1f01709189c11739d7"
  end

  depends_on "rust" => :build
  depends_on "scdoc" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "make", "docs"

    etc.install "sniffglue.conf"
    man1.install "docs/sniffglue.1"

    generate_completions_from_executable(bin/"sniffglue", "--gen-completions")
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/kpcyrd/sniffglue/raw/163ca299bab711fb0082de216d07d7089c176de6/pcaps/SkypeIRC.pcap"
      sha256 "bac79a9c3413637f871193589d848697af895b7f2700d949022224d59aa6830f"
    end

    testpath.install resource("homebrew-testdata")
    system bin/"sniffglue", "-r", "SkypeIRC.pcap"
  end
end
