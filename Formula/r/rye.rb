class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.30.0.tar.gz"
  sha256 "9848ebe221267153e41b20008e73395dde0f82527b1a311080a4ee29b82a8fb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cc2ee3f4ad74f88aecc622e7d31e6942b460862e4cd4d57acfcf85a0c1d4462"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a22d80027c3e8a6b42afe40e39a7dccade692c239ca1b311aba5edb27e406194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "623a4f93da86ba8f1e3a7c6e063d17b0e8ce1da7e834c84026fd98b45ef2d029"
    sha256 cellar: :any_skip_relocation, sonoma:         "92560b6b91a86ba9ea56c34d6f108906baca5a39d9f8a6634cfa6fb24b3ef56c"
    sha256 cellar: :any_skip_relocation, ventura:        "52517d4ad5c7af21be70c76b698a431967a45b2e47cef99a63b98832f4139c30"
    sha256 cellar: :any_skip_relocation, monterey:       "37100ddffb45679e8e77ca35c560ba4e4abd649551db4c84bf57b0d7609d2d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848c5958d447ad32bf76c32780e7d329975c741987a1dd7efb22e43a9c632dbd"
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
