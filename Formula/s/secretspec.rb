class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "c466e633fcfd5fd69f8ffc72d77442b8dfce640eccf41f52be55ffd5968298cd"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f463b91b0b2cc1721d4d7cdf90a2165e21f04bdb0e9b86e5bc56a7d7b90cbf23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7514fb1e99fbe559b3ce8f47abf9047167b26968242d017ef128d4abe65c3da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe17adf342489da1682ee602e057db76a07fb4f19c670e7ddc97104e9db6695b"
    sha256 cellar: :any_skip_relocation, sonoma:        "461adf64bce62b5098ea0e462d063f9126e1b9f10e38708fde066be6ddaad22d"
    sha256 cellar: :any,                 arm64_linux:   "ad06f2e33323dd5fe15377a33f3973f36f90a886740ef081885a295e6e07d623"
    sha256 cellar: :any,                 x86_64_linux:  "3465eb259f803dc04840fefed8e3aaae914cc8594bdea38df4c472fb4fae130f"
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
