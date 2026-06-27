class Rye < Formula
  desc "Package Management Solution for Python"
  homepage "https://rye.astral.sh/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.44.0.tar.gz"
  sha256 "6ef86ccba82b59edfc4f6deba39be6394e7866fe2250596b96124c20327f0581"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "698508449b2199f07b4fa53f575e0ac39441af255e04b96a6b31e679a7e175cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd55a7654c655daadb3a8d6a7849dbe07eaf050c453977716bc9c9675b12e3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e717a03a4088f7f6c176a4563e1988d8fe04e3512ef7c885fad645ed3f07c03c"
    sha256 cellar: :any_skip_relocation, sonoma:        "233a1f0f8520474ccf2ef277508fb00bfa2730334cd267b2342bbfe861c7aeb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a80145bb44417eb51eba5b3a66346fbae0865e4f6372e236ba0797dc23d1c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6d7bba1ebf4e3386022e0b9863c8d128a76252f03c0633a5f253e556cd6fc6"
  end

  # https://github.com/astral-sh/rye/commit/62ec9edbe471958a05a70418b19f3acd54f0484d
  deprecate! date: "2025-08-18", because: :unmaintained, replacement_formula: "uv"
  disable! date: "2026-08-18", because: :unmaintained, replacement_formula: "uv"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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
