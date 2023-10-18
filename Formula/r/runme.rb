class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "32b75f73c4183abdf65828a280982b834e7011c1bde27d305d09368b216931d3"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "120d91ed91d367e5f7424f297da5b11d595d37fbdfc80e7b34ac4370ae41e14c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e7e2f65516965c279882513c553e9ad9cf48b9620d1b85a4d629afc3bbd6e6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45dcd75ed17155b62061f9c0deece443542f220ed923f934b8d2b9d65caae24f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ffdc5fd123c16f9bee878be7c11881a513be29a28b3c40a6717b77a756f56c6"
    sha256 cellar: :any_skip_relocation, ventura:        "19386f7987234fb6d864ac142ca16b2767f80031544bb43405cfbfa18c218e91"
    sha256 cellar: :any_skip_relocation, monterey:       "d37da358713a632a928eae1779498d60e60d8bed445c4cdb153425e842ff13e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "123ca1628302f0740ed3670dfa477bc6c612bf4cbcfae03bfd9449f41563eacc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
