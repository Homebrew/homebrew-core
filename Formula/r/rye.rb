class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/astral-sh/rye/archive/refs/tags/0.38.0.tar.gz"
  sha256 "16cc21660dccc9a66ed5086eb96cd1d571e1af8145982cf6e56fe918e3ca062c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daf0310b6a346141f25530884dc919d13890cadc1a95fd849d0af6c1e13839db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7739729205d86d1eb5ddc43e1d9afb248081acb0ce4700775ec29d28e09c8c43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e545d4ab56570b31cf71bad2403eb8e0e1a46975929d2160349a460d954cc1e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2750a8dce06aa71cb7973a7ad7a9b319cb441d83328ee4cd2404a24219b99442"
    sha256 cellar: :any_skip_relocation, ventura:        "ce07b9f2ec6b71717392611ab7f8a28e52075792625c3e1596c15b7554b22000"
    sha256 cellar: :any_skip_relocation, monterey:       "796f6de5176222417163f67eb6925f1d033ae2ef2c3820a9f18f0f2e0632be34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beab605fc5df80366a29d48dd20b6f82fccadbf4c1d143d90a6b4526f74fa2cb"
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
