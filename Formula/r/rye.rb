class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.15.2.tar.gz"
  sha256 "2ee835db0697645e1a902f47e1404173451dd5624c72c0917330acedef3c4aff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d26467492066915dce15b3d0cf8e9fdc54108efee6aef1d77faf6f551522a7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2679e456689490fb3d7d2d2bef12cb12a004f0fb0b73f0f7c7892842fcf9225a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "819a338424559e3f5ed8cf5425e773f49d43ee914949eed6080969c919ee475a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bb71d1fdaa12184308f23fdc14a0d68751d0d50ade8bad60a7f19d1b363a9c4"
    sha256 cellar: :any_skip_relocation, ventura:        "86c41769b42bc4d40978a779957028f0d896d84c764b617f3bbb863697402888"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7e6a2967d55b194f18d060c5222f5142b0a3a858979706e04d3a0cdbd0e2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a361fcd76d019931ca3bcd54804b7767a0661d96ae639eef6756faa38b827ec"
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
