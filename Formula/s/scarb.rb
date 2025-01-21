class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "8d8f9fcdaaa72a961d170dc3fced8cb61bb463a185debb654648887c26df0956"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d678b1b4c846e5609f5e5cbbcc61ea0c4d806d36d36f196344e8db9bd42d636a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afcb3831f4c6c0ccead56d2a3a42c7888cd3d2601303468878961ead9b19b61d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7de68a58f8399860b8ba9f5e6e5148771c819b1b098ec87bb390f54cf0d33d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3eefb90dd68de76e89e0b15d686ad1a1dca7a5843852c438013a3c548cd5742"
    sha256 cellar: :any_skip_relocation, ventura:       "8aa066a4ba0569a4eaad4ab85665261f7216ecdfe53315309a812ed5d9a9000e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eb3e91b7c564b45a83ba1f1845ae939a7be334cd242f9984c3ba88a1188fa45"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
