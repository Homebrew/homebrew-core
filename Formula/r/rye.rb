class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.34.0.tar.gz"
  sha256 "a5dfb435e5aab92388d8950d8772c753a15b34593916279d1e7edb64a9277340"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e41615465f5aac05607e470cc620722c75b39832774d1307a6ff985838b6bf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4f36a2de6d780c8e982d75c7ef3edf45e191e2941ee2cbfe90c148a218d018f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27ad93144c345a062bc3f202b4dda5313af24a65a4a68b899ff67fa57e04e90d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4edbd9ef5558393c45742c52a38d355a0bfb2d561e6a2d78eeac7d031e5b13f"
    sha256 cellar: :any_skip_relocation, ventura:        "dc0333ab9a08b104e61cff0b1bef810e2a7c55f108168d76f2b0592d0257e85b"
    sha256 cellar: :any_skip_relocation, monterey:       "f2276b5bb545491365158fe8bdf5a279c13a075d52b3cd4efece0dda8665a007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec07ee9564eb8e1e26e41da634c140f1fa4787026dcfe60c22b7d055811820e"
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
