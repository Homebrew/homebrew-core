class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.29.0.tar.gz"
  sha256 "2cc3fb4418fd2c5568e3c8cf366f94aecf0d3c9ea9b87022c699e3f17d4525d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f77c19b1cd91521efef0425dd1458785289bdafa681e0eff16effe80accf744"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1e755d46b852856af0f17cf0cfc6705ddfa36285b8d98a8ce06b50104a8ff13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0ecb55c58f9465366f0fd6ec071ded034b8d5f00ff1a8e9e33e1a8bedcdf2d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf33cc8475789648ec81032050bab094a95ffcc06706d49b77b9be556e89f6b3"
    sha256 cellar: :any_skip_relocation, ventura:        "19cf082fa80745c7cc9cf617c9f14ca9d02c9d7e215f086649d2a590e34c0b8d"
    sha256 cellar: :any_skip_relocation, monterey:       "5afd6e3c7cca09aaa7628f4a7200f0ad6d7a6faeccc54945c0fb7ad60eccbda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0dce2229ea35d98b6dad7705dc82495a2aeae7b262154c6359e9a561e1c0f67"
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
