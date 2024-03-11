class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.29.0.tar.gz"
  sha256 "2cc3fb4418fd2c5568e3c8cf366f94aecf0d3c9ea9b87022c699e3f17d4525d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3cdc70f99bf996eb9c5de6ebbae85ba8cb4b6ce6dbf8b25dd5c978d2d44fff6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cddd3def26f78ce976eebd4418f134d69316c7105ca70160b0ff82a98e52eccb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da3520a08408dd55ed2fe887c5529399cecd70fac0512ae558d202065cc028a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d034307ce994e496652cacb2cadd07e462835143e96bc70267e77f8a1bb824e"
    sha256 cellar: :any_skip_relocation, ventura:        "c58770aaebaefa8fff3932a9cf34f51f040bc23810141d856244cb05c2c8b588"
    sha256 cellar: :any_skip_relocation, monterey:       "e43c5b51e87b1cfce317980fd3de7f92b4c58412f88da9f2c4ba93f6a6bd7271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b94b5590da9e76d34d147bd938d0bb4786ccc1ecc1cabfa005c07d42941c0bf"
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
