class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.16.0.tar.gz"
  sha256 "4e86d8f104f99b3c2eefb88a49c527ace272a25127118c932ef6e850b57907df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da1cf912c71565d0ada42ec704555ae035b824779f4c0cdcef087391934ab1e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3ed5ba5eb935ede8643ff8e709bbf6d742b1dd0c43e459c1983092b2221d1df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "856a6975f3b9c55f2eb93c44a9a5751ae6b485e15bcf88fa77271dc249b9f091"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a6aff13c9adf773df93d0e8c7e831668cc8c53b1143d3d28ac8d0172584c16b"
    sha256 cellar: :any_skip_relocation, ventura:        "377c330c92f89ceb2e0892d6ff2e03ccd4d7b1af7dda0d52b6fc9fd4f8a6b790"
    sha256 cellar: :any_skip_relocation, monterey:       "ada19e54b6d615bcfd22c19a252260f414ae3d2eb01fc5c9162fc2e3cfae9938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e91befc98a3e0a70731ec2f44b88e27680db1f40b4484b4fd207ffdf9452c3"
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
