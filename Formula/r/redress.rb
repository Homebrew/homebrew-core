class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.82.tar.gz"
  sha256 "616cad47d47a70173c50b86263bfe690e70468b66c764daa8e1e80b10a256402"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad1d1553847f6437942feca30f26fcc5c5418a618919776588dc8a10eb6a9c1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d3741a38cbe597984eaced076c81aa08ca8274dcd8d7464e56e76bb55bc24e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19709850ec3b3084fec812a38e8b7765b46fab692c4db00628d41436488c9ce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e69627c68dab6538fdfc96fc35541ea9b73ff8f912c92388e514234bf331d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffaf76c2ce387de9377b17647c88a514f75372819692571730f4456623b2270b"
    sha256 cellar: :any,                 x86_64_linux:  "e57f192814a7281c1745d8fc5f79adf5e69d6c65ec24f1519832fd98114e7f59"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
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
