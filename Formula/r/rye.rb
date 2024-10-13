class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.41.0.tar.gz"
  sha256 "d3a73f7ce2b837dff7fd81928f12cfd1a2d701efc810b5f0d902ae10ca4354b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac78e0e5c036bf46a8ffa4deebf7ccc87b0f8c22998bb2a23047d3c0d4272d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8155ef2512db6c362e73e7a884674119f8294551343150c938f9631c99049b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2890ad2a437df14750bbb65e7407f6d04b054f3dc1a3deac7a33223917a46d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a49389f2221123d72419e00e7ee6516b07416d4daa7b0c91b5747fadfb740ec"
    sha256 cellar: :any_skip_relocation, ventura:       "4db58aae4410a0c841b599684acce0f77682b79fd88bc79a3697a6e1b1a53123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4154afc1517d204c0ea739d61cb8ae498d0b7500a7c4cd7200a4a25d08a14ba5"
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
