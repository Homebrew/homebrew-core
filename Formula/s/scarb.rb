class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "e2095fb89be685917d3d622aab5531dfe1e3a7c9255b56122c7a9216b1f922e6"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5b874f27a5f66598c2fac5f8ef7c2c3643c464376e6179a9cec1e934d52f909"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92e7720bf48dc95f090135c4f1e008f362e375fe1a7710add66f420cc69f0d89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e587a1ead8d7a913de75ad0f157f7275ff2cfe370e69bd0f32b6eab63e1cb746"
    sha256 cellar: :any_skip_relocation, sonoma:         "d941e2124c10491658e35b5d72030a5667a2019a3449d49dc5aa46a69083e82d"
    sha256 cellar: :any_skip_relocation, ventura:        "7e4e2a247638e4fd870ccd95f59741c9164cb1d46a770618157cb74c9c2d9019"
    sha256 cellar: :any_skip_relocation, monterey:       "36217e62bf576c7b0388603429bce769612a3686bbd39d2aef0ca8e3fab61dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1efbc2eeaa8b818b6262ecfd42fe069584503d2ae4ab7e71b7c4e34c9de0135d"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-snforge-test-collector
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb snforge-test-collector --version")
  end
end
