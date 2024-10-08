class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.0.0.tar.gz"
  sha256 "c4af5ae7c03b92d726301c56aa7e6003ae9ba3d852afb77a8297add7001b2cc3"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "728b95806adb5272d8611a7923aa78300769408bb5b0c28d720b18fc32fb7279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e128f9fc99561cf9965660590dcd3c858e3234f147d618e5696134ece0694374"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ad242079a25c1d2f8eabadc70c25014c754662a94b5c1911cb409d6c676cdec"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d6f4d713e7b1101c8794ac5741ef1b00873751e6318d05de9cd447c8d8a082"
    sha256 cellar: :any_skip_relocation, ventura:       "73972c7fce98c4678ded9d76dfb93cf0155c93e58002325da6aa0c32cef1d3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "614ebb965c4e21a69d85c14d919a9c8ee68673314205ab86116628eb55911f42"
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
