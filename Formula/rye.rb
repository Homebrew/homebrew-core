class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.7.0.tar.gz"
  sha256 "89699ea825a27aa76754c5992b095ae1ef4ba654487cba70a65f452390ecf5c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "049b648a3050fd637f0ab67465dd4ee6c88b4f83c0202edd484f16571434744d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce79831212db731e03bd025aeebe0fb423696099dd4e686227ba415d34dd170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f3039d42bc3eac21a2b1a0b749bb135fb6931458f72e7dcd5f05ec0f038127e"
    sha256 cellar: :any_skip_relocation, ventura:        "457d5939f965baf17e4985c3847b15b2e4ccf06989ab03f13e42592e080f54f6"
    sha256 cellar: :any_skip_relocation, monterey:       "fb044a019335db29caf3d12df898853e5e656c34812781c290b02d8b581e9797"
    sha256 cellar: :any_skip_relocation, big_sur:        "278b3a39b38f7999a3a00d47bab2220a07bb07c9da8576eb4abe85a2b683dd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc675d4bd5d8d8dee34a8cf7c609dbdd96c8b00e0e6e523f1053d0eb090cb886"
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
