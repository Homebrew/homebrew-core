class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "f30b31861b07160b4efe23eda996491aaf885037d6907227d2230cd0e7db3265"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "380179cc72c23149aaed5ef6524bc6f5f2cb6b0c441adf7cfce8d53a26026143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5184107991133eadf3083906c31ccb12ce9c545f0d23510a791921ce27e7aa6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5566a2eaa0cd2f09dbfafe380e78347697f1776022aedb042415e799afe19a94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b735be9699cc3e29c84d333e042f6b3fddc2487936c22c72990c7baa501fa640"
    sha256 cellar: :any_skip_relocation, sonoma:         "824312cfb5ea09c0783d1401716498ce5e1440ddc598846e7e52584b5ec8abd3"
    sha256 cellar: :any_skip_relocation, ventura:        "01fe539139d46b95f1595d859147698203873b8a616dbde21166c760bca5cce4"
    sha256 cellar: :any_skip_relocation, monterey:       "d365e93066e3ee10bb2d0e19388d737475b380d9a2c6b737239335f912cff165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199b66e5139f7fd082bb6d3df7795b4c861df4df7fabf0bdd345b33b49c92024"
  end

  depends_on "rust" => :build
  depends_on "scdoc" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libseccomp"
  end

  resource "homebrew-testdata" do
    url "https://github.com/kpcyrd/sniffglue/raw/163ca299bab711fb0082de216d07d7089c176de6/pcaps/SkypeIRC.pcap"
    sha256 "bac79a9c3413637f871193589d848697af895b7f2700d949022224d59aa6830f"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "make", "docs"

    etc.install "sniffglue.conf"
    man1.install "docs/sniffglue.1"
  end

  test do
    testpath.install resource("homebrew-testdata")
    system bin/"sniffglue", "-r", "SkypeIRC.pcap"
  end
end
