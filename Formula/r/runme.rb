class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.17.5.tar.gz"
  sha256 "d7c550e8e11fd5bb9533275885e92d2862eed5dee93c3c4f402860ed0e34ea28"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a04ba2e5832728b80961cd35a2ed6379f9f7f5fcd3a969eea17fd6e9037a3eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2542d4a9fb82dc14fcb107d871f44273990b56adfd1d592fc5e068878b6f3660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39f4600a865dcd993035fdf2cec528b8d2161cef5516d005004cb2e3aba3cb5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "73531e9931e4e2a3f448191ecb2c75a036b2b3f083bee1ddb73abb09a19703e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da897f6f2c6c756fa20119c1856eb1802838e14f56d5a01f6c67b474d00b5deb"
    sha256 cellar: :any,                 x86_64_linux:  "018f0a7b5cd46c83d1dcc1eb7ff7826453d173184c906acdbc4e1b33995b6edf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
