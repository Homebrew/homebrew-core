class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "bc9ead1687b8a0432955c2046f88b2d0aac153bf242676390103771cba6dd7df"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c9ccccd8bd69c148c686973a006980c7a3ba0af77b82ca6db9641d8af5c3226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ce75d5df2bb54624fc040ae8e5c8b59cad11bbeca0cd9066677556374091d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "304362c459521cbeccb204217eda1a69d4280cf3540460ec47d8775f4e7c183d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a0c75bfde3164817ec82b730dc1f71d906f2364f5d0b7c2b45ce40b4ffb7c13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95b5fc0c7de6a996c162f13322039f21071bd78203b9144b5fe1396a4772e179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a1dea78ae72887fb675e1a8641d82bb02385aca3297804559e70208707a226"
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
