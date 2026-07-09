class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "35ebd7a3a35f909284a573859ed1f082aa0fd88649303b86f7e37d479a8ca2f7"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6856b9552b2f65324feceefacaaacf4a97d650edbefba8b7769d89148cc09d49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09cd76533b7e03bea97d153fb69bc02d7222c07d1524be5ed127eea90750cbf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab31f66698988ec510b61fb7e8b91e688717fa2cdad24dc8970b3b7d8d78bc85"
    sha256 cellar: :any_skip_relocation, sonoma:        "79621c8496ffd3c8240e18fa2daaf4ab40fd7d1ab9fb8ef2542d9ca46f621be9"
    sha256 cellar: :any,                 arm64_linux:   "629dd9174d96150994562b4a20c66eced4a32221b836f1fb3eb7ca091bfdd72f"
    sha256 cellar: :any,                 x86_64_linux:  "1fd0b1e93f5420bdad61a25b534e448d0bd1b3ebba8589e11f6c07b2256b3e14"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
