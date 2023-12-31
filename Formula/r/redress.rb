class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://go-re.tk/redress/"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "60b8c6fcdeb4516c32ce5bab40bf345db995f3c2a80561662a190c37eb3284a9"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eeea20a7dac4321e6d71aa3e99ca14974f3d6a2fbd1e11a0e373bd3710d052e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49a41d2a3a7c67218a6e04d0d1ad1d160accf733d98f6a1c66cb65ff8eece781"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e6536d539e76370c1cedd96ac714570681ee6c2bc8bd300a1daf9a3cdf297a"
    sha256 cellar: :any_skip_relocation, sonoma:         "960ae46da4f2de776b2855c6d07331cad36917c7e62f315e7b63ef4430d32b72"
    sha256 cellar: :any_skip_relocation, ventura:        "a065408fc5e32c52361429740f5e99120933b0e1211f5741bef3a596e62c924f"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1450857222012c2e93045aa4d651cb54213dec9db977e6e7a70fd9d7135cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa43b152e48f9adb04fe164784898a34def73eb5d619d4c87b433404fa3e870a"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end
