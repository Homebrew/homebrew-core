class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.33.0.tar.gz"
  sha256 "13eb48496be1f10f043551eadc1446d0c85a31bc2a3d2117fb02d9ecd869d99c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3f3fcd590cd13367c4299e81b5fe5599df71c89ae78da31c92bafda06b8a2c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b28f6ab1cb399962655ebaa25dca7b0ce4a5828f0e18ccd2a20db4ffb57755a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98b410681143db77d757355135b7665ddc45307f8a300bd67b5b1bc6500c0943"
    sha256 cellar: :any_skip_relocation, sonoma:         "be86f886969be552818bc6fb39b45a413bae014340539b60355f1258038de647"
    sha256 cellar: :any_skip_relocation, ventura:        "b494771a3811266b77f7e462ab6f79201382c30c27d76fe17ccd1aa2081bf262"
    sha256 cellar: :any_skip_relocation, monterey:       "590d7fdc8cdc290c2645919fb14d33571264ec82a25a188511064476a01b9a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7227ea63c00bcab8cbc4c38669342f787d1523e09a421343d04b9b89972685ef"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
