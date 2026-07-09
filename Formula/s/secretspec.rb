class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "771c22deccc59850022c976ddb177c5bddae34c0ed7b46ad977d45e47af4c992"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc79fdf82784f76cf21da02766aeb8576e1360d254a28f2918075d3f040209fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3773996681f256ad219d03c0c6058c4123dd93c773ba6658ba8fea2ff6ed5799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f3c99c7d928488acffa082f9c707154b497fc462464da852ebece59eafff319"
    sha256 cellar: :any_skip_relocation, sonoma:        "62edfdaefd1cd03370c2c70212e6bfb081a648d7a1ee411a18f93b4ce5778add"
    sha256 cellar: :any,                 arm64_linux:   "2fde4515e5a66823459b3906f8ac54734f047fa32a782168737c95b9f4f2b33f"
    sha256 cellar: :any,                 x86_64_linux:  "32bd007335e7277d8fbb259ca0a3ed795ce28768ae45f91da594da0b3de87852"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
