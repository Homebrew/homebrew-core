class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v22.7.0.tar.gz"
  sha256 "253ebf1927323c8899501f4db21914e48beed07caced9e626b035839421ce582"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03b62ed13c68b1f3500f5d781ae3f65ab35df488b6f6b9abb6aa19ff788c8632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f3802bdd31dacf7330166bf1ca27add6295366372c0765c693ca8ee02bd65e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78fe1fa3cc4892a5eed6ca674117a1ae5071591e2cd2298501849efb24e05935"
    sha256 cellar: :any_skip_relocation, sonoma:        "168f5ad2820b3f1986eed094c67be4268c6ced4407722e80cf865f6c97c1475a"
    sha256 cellar: :any_skip_relocation, ventura:       "f0cb009173a4969b9f83cd6cb659b7591e72978ca2bcd9244fc28b74f288f793"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e555c3ac7ae4290eca98d7a30912cff629942ff6d7ef675d5cfdc0801031cc95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec9ea938d694a78bc7a8e4c9fa6c9924c641031ebb8e155d703ee7963d76eae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
