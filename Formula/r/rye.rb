class Rye < Formula
  desc "Package Management Solution for Python (consider the successor \"uv\" instead)"
  homepage "https://rye.astral.sh/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.43.0.tar.gz"
  sha256 "e4106514141a2369802852346ad652f9b10d30b42e89d2e8e6c4a1dcbc65db6b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8738dbbddc915bc6f23f256396423e4a9f723eef7925b30457ba0a35e1ba65d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7fa020f3f928eba9626f7561ba901415e8aaac93a1e1a20004cb504474134b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efc7b793ab8ee7beb7b37c8b29b1d4d6f79d97bd64dbfe00af85ef9130ed97f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0c3950c924c3a54493a32aa22aae2d87e7d01bd8460a10b9461051edd0a75f2"
    sha256 cellar: :any_skip_relocation, ventura:       "99aeeaac2232d2888854bdd2a12ffcf90fb23c2837fdc64d4c679a77ad80be38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c848dd8dda2193696a7f30ffcfa6aa8de93ec4b549968ec38d254781752ab46a"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  conflicts_with "ryelang", because: "both install `rye` binaries"

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
