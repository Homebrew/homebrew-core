class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.0.1.tar.gz"
  sha256 "9cfcf31db3322f536f0c48d8a75c6750f18762e0ef60eb7446e3d4a0ab60853f"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f7dac89b366e4c7e817457753c147b66635d771300dabca3c16704a054a47f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1f70a67f48a3c9a24df134ce63d32221d828b7f7b1dbf08227e21e39ec26601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97b54bbb40a123e14eb1e6ce0d26d17d40f981d7c82cc9f50ab30d5b9cc93c4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a7adb0c20cd12ac0616fd889d65decb2bf8b05ce4e7d0fb691ae1f15632503"
    sha256 cellar: :any_skip_relocation, ventura:       "e75c776c097e99ccdbc5f5b5d006766585708dd034ab6493a2daae71f03f4662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baa7be8397cdf5ce4093ee50e0735ae8fa68a29e77adf1b6d747e5182af4b3ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
