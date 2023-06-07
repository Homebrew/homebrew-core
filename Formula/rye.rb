class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.6.0.tar.gz"
  sha256 "d3709903f4419fbee567fac03b44698b8ce478cfed03deb513066b4e663b6400"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de34a2b55bca8fe144ee64ff5b860d8682eec0c70fcd904c42470878b6995941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0341f2ca619c903637877a70fd82bc74326e321c6129d1c587f5ebc1cc093883"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e71a1af49bebeeabebc63d47dbfb6e30c02c7e547eac661c3d1da431ed51c60"
    sha256 cellar: :any_skip_relocation, ventura:        "9fcf4362d45a484bad155fab3f9926aca4b6fc48d09c64754f64bebb2984ba3e"
    sha256 cellar: :any_skip_relocation, monterey:       "befb3bd7e1b731667178d24e679263bfb5f26ed29aa57a0e48454059d72d054d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f711211dcfc85ab351091bea401b6be418a316596f2270a0425683b697368a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91b740d3b0a6c79834948fffe8ebc50fa082fa9f17f7024e8f0d7e797bd824e0"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
