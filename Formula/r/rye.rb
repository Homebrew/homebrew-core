class Rye < Formula
  desc "Package Management Solution for Python"
  homepage "https://rye.astral.sh/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.44.0.tar.gz"
  sha256 "6ef86ccba82b59edfc4f6deba39be6394e7866fe2250596b96124c20327f0581"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a36d38e6a1aadb4256e49e51c210fd551bcfbb42654c40f0968441f6c588934f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f26f53e090a3f1c42b880b7df2593f597e4294abe311fd1cd0ca1173cc49e5b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e502b9c99df1d69e7caef8e63e23aed06816b90557fa487d18f6610901b13944"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6b74baa377f0ba45f330e370166b5666e1420ec0d6c753b7a375c4fc2d8ef40"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ac877425fa7885188dcda9743f46146bcd57d835a721f7958a8a46281357f7e"
    sha256 cellar: :any_skip_relocation, ventura:       "31699f1f7848d15e13d80139514bcc479dca399d2dbf6129884b1e0f2a372047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "800c9ebff0b4a200313646ad3b2db6909121a2ea8377e7d33254d09bcbddedb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58b4ad1741833bb23f3d4411ea72a4e17ec013961dfa3ac152db8bd73fe1b30"
  end

  # https://github.com/astral-sh/rye/commit/62ec9edbe471958a05a70418b19f3acd54f0484d
  deprecate! date: "2025-08-18", because: :unmaintained, replacement_formula: "uv"
  disable! date: "2026-08-18", because: :unmaintained, replacement_formula: "uv"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "ryelang", because: "both install `rye` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~TOML
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    TOML
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
