class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "8569170a922ae797c0710d2f41044e246c0057372accdaf65122d959dc90dc3d"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76de8f68c80660142148a183c9cf49418b739894209c787d431f865e9ad1c19c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "123b2e74c15c735abde55f2d1cd1b730a16671f77771b494b1059471f3f81bd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fe9923b70b9d43dcef94cd6d85e8d5e5abdeca2fb5e5896c7f1cc2e0b3a6721"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdb9779a6af45452ebedfe9096d6b780bf78fcc02a14e15bf338db490b8a8ce6"
    sha256 cellar: :any_skip_relocation, ventura:        "52b6e26904840c7c13a4c04dd9644cacdba86d22d0741f9345ebd3887c9868f9"
    sha256 cellar: :any_skip_relocation, monterey:       "11b72281f271c2d8a676e3581c257f1ead52ebf458b28d9d21e505a20039d000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0827138d4b5606c08c1a67089b3f45d4522995e80182494d00bb303577026d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
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
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
