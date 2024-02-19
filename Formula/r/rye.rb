class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.24.0.tar.gz"
  sha256 "867294272aa6499e663f3aac3b85ffe69093497e8ba8a40b22d39b95a9c80847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79f6f8162a71c5faaa9bc9d9fe68f61eaecc4e341f2688532bebac6e7a99b17a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6654c52309891e2a4a2cbb3e02e7a25bce0592a25e5278ca20716298ea4cbdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bab4ec5049fdb0759eca046ae9dc53bdcea4f5b3f3d108d813b2b257462d1c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a1ff2a4bc8291fe87011279173281f12cfd051704e9ccdcb7096316914ac90d"
    sha256 cellar: :any_skip_relocation, ventura:        "abd6d67cf520a1c276579b40907c46dfca1aaf9dedd9be4162c2ce5b390d807d"
    sha256 cellar: :any_skip_relocation, monterey:       "9d0e7a987280dcd2ba9ae0e178fbf93c3059ee2b43458c1cf79a7c47c2ee2485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b24235579d2af37a33c63094ad14553ef95347707d079ee98f600bbcaa46f08"
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
