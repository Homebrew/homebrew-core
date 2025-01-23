class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.43.0.tar.gz"
  sha256 "e4106514141a2369802852346ad652f9b10d30b42e89d2e8e6c4a1dcbc65db6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d37a06c4a25db7bf068e0c534215482fd1ad649b6ef7c295a89368f46b30527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d4940ca01a25e10130857de4c5b3a71d828c4fddd3579fd3740b8f72405f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b48117cf72dd83653d6eeabb027a32bed37efb8815e9818a4c40c3019959df4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab8662050bf34d342b01a155170dad6157cbf7c75a2dbcebae6212ceb36ffc68"
    sha256 cellar: :any_skip_relocation, ventura:       "9c0b2d9a507b2a3dcb9a0c3352b581115115f22f781026d6b6f998f7a2c1be11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac3c7319165ae16dcf4d98c9f29ca0c44cee22f365a126970b5d870d5a0865a"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~TOML
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    TOML
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
