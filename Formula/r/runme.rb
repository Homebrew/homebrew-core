class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.5.tar.gz"
  sha256 "a4fb24c2af29e14586e7a75353a37a5ac901624662593e5663679001cab3259d"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bda0e61227f5a597835d07637d4f8e384cf15e67b63c151cfd8856faf192bb42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef3f3c9b3f1500a5c192f4bc7a5006932b42202eb2b2e80e455ba7a0a2732bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c0af34a27838319c13908567a46e17d50bf7bdd098ded7fbc71616d257ffc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "22adcc64e262ba08150046439c88822f988e08195b6eed73d55b1f3f9fb44b24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19a56c27a5371dc2cbfd88a11cbcf487e774d91fae856ec58e56d2d14f15a56f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "877e785fa88a28ca95ecba232b01c1ca75da6c03e68491da19361900b51921b7"
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
