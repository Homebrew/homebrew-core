class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.56.tar.gz"
  sha256 "49ecc302b2fe8344be0d4a9265998b6fea8e46f293bc436c702123ecb36421e6"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e17093acb1fa75c3a8b61197edbc50a9c6f931f82378829dc3c46f6aebf5150e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6e4eed9195d70d6407f21fd10ce027e7e185f9dc629f692f758eb05b079351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a161fe7517bfffaf85b0b928b4c8ae64ebc85c6899adfff36a0e10170b0337"
    sha256 cellar: :any_skip_relocation, sonoma:        "6380c68fbddce53917e99cd510e4db8be868328ab6846c3a923d1867ce3f154c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5744a74a3feafa88c6bb1718dd388861c3c94fcd830971fd798508e3a4687028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6739cd4e107303269fe247a7f4af0f7067499a95437c18f28b9e39c21993f9ed"
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
