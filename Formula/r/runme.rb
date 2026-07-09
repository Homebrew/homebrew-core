class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.17.1.tar.gz"
  sha256 "8fb1cd62ebee83100a326dd7b53c98312d9086678bf10e10375feaf0a64a8ddc"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c70345ccfeecc4549b52505c62cc8bd88b5b9d8787560fd9fb34af6c3469d759"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "397bbb4cee08158555cdefa22f4407c94e8757ef280c6e97d24e5bf1f2523620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f125641c8a979f5b3cbdc7f8b3ef4ef2947537c0b476c59ce9c1c9b95859af2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "047bbd19b5ce3f18dba5a4834dd89975fa1679e5a2434622fde8cc729e6b57cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f168fb9e62e1700ab7141d2d6eb815b9aab6e532ab1bac4d17ed1877ac725a94"
    sha256 cellar: :any,                 x86_64_linux:  "3952e01c304e299556b9f134b2aa0b3bafe53a080948c4b989ec0acea2a6a83a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
