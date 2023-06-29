class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.9.0.tar.gz"
  sha256 "1c10ed82fa4c0ecc4df40bedc45c7d3de790caadcdb1907b6e17742ae0c68175"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4cf0a54c27c22ac9813024186e9538dd75bd10e0f7f29f3b5eabf6c3f8f5482"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baac672864846909eb9c7065b4e53a859f5d693e2274fc76aabc6198a06efb2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01ce119bec6a0fd775dea62a954d969fd0cbfcc91ee5bb2c0fcf42736731383f"
    sha256 cellar: :any_skip_relocation, ventura:        "bea04c13de54bfc3e4f33abbac0d0a6ac55b8b30dea534da61b5f5d0913ade43"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd099b466990020645e6e116373fa2f09e94d80d7921e5c09b9b5e1c4438ffe"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddbbcc139dc1212094fd6ddf538eccc83c7fd98a08d6134a104fdc25796b7491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d3e8d213943c0799d12a66a105d5d75a9db98c1c682e5c1882089d1c839acfb"
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
