class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.31.0.tar.gz"
  sha256 "074056cab81ae22e5a1af452c4aa37726a88ea72dfe53e6c3b642ed33907678d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "765bfe5140afa5e627bc71aa234313005d475799424c3fe22482ca1ba550ba2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d698dbffb798112037748025ec7e21376e87f8c9f1067500dc4409b91eaaa1c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efe88d7ca8b5358ccd7aa18f0ab0df393b72fa75a3cf04ade4856b092442f908"
    sha256 cellar: :any_skip_relocation, sonoma:         "68d9c6d8e0daa8de6684f421e8add1bbb6790141f13a3e81485af0c71099fea6"
    sha256 cellar: :any_skip_relocation, ventura:        "59680cf3f1a3b9f7345d39029f14e29a0d4c3741a554daa964b60165253bea1f"
    sha256 cellar: :any_skip_relocation, monterey:       "28727a6812e37feb76c0a8ad3540eab364fb1724e6e56d7d5c6e783f286539f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65269c97965973200ce7ccdc38c939cd8bcd5e41056d8ee7fb479b5e6c8afa47"
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
