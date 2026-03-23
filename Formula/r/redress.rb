class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.59.tar.gz"
  sha256 "193e9f0c494d725911570cca875e9562cc6f79a8d159128b309b5906aaaece6b"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e401804b752a064e8d9b1d2aa52bfd2bffe833e10b6adac1db66b69bb5bba46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499277e65751e7c33bf5cae569d2aa163a80135734c4093e892ef88681120ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "911e5c49395a17e57965b7a58c91df4ab5ce524aee27a0e6776a6ae670d27135"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ed40dc85bf31f4f47eed711e59f30de4d47471cc2d256e6280787b2ba85aea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c39363da117916e6217b2508ec5e7ad28c88940d5080a29d30eafbf9da84a176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c7c68e69d668e931edc594baf7ba084e5db74e28ad81823932d33eeaf93b3b"
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

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end
