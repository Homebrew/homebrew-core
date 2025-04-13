class RustScript < Formula
  desc "Run Rust files and expressions as scripts without any setup or compilation step"
  homepage "https://rust-script.org"
  url "https://github.com/fornwall/rust-script/archive/refs/tags/0.35.0.tar.gz"
  sha256 "21061a471cdb25656952750d7436f12b57bac3c292485e9bc71a5352b290d5df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84ccef7a3d517ba17b93f95b279529a318501e56e9d6e3c7c9c6122b10c63fac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "960a5c6f1f1dd0c988f547a6de1635c0512d6ee77f9efad1d906484cdd52c03a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2efbde3d56b2021d74f6c0772bf2a00dd8247daf238fe4b7007ecf460dd1f63c"
    sha256 cellar: :any_skip_relocation, sonoma:        "77723dfc277650d524677611bc1914271411690dc31b833cc787b2d78a867e7f"
    sha256 cellar: :any_skip_relocation, ventura:       "ebf09f25a4d8584d832ded2b7a63ecfc6c23fc2e70d440c40ee32e7bc33883d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c0f9c4fde1d78f136f71bdd2bb4a733bda3142863e48bdd6e765ff30ed74cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4765b6c1f979d3cdae339ed53036f782f3701f5caaaf2dee6e2c2a38bcede3"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "Hello, world!", shell_output("#{bin}/rust-script -e 'println!(\"Hello, world!\")'").strip
  end
end
