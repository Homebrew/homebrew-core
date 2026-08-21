class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.17.4.tar.gz"
  sha256 "73358cd7a14b596b151eba1cb82772f533148a2d5134d612ca1a2c91e0ec237d"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50217fe8cb5fa21a91baf23311054fc42b15d98dca21576a0f2873fd5f3fdbbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467162e478d4ad54bc6f6c06096db5bf4d61cb560df8246cf2fc5a859c386c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3d5056880b1adf8f70ca09b30bbd1a3b1e9d28661efe01b8bdf1b727f373c56"
    sha256 cellar: :any_skip_relocation, sonoma:        "0723c37abdd92b9e4ee283ec5949a1ee8613a6745897f76652cc26d36e61e674"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5541dfc06cca2b842b79c28720739d38fc862bee92f79b511c4481454c7df4b8"
    sha256 cellar: :any,                 x86_64_linux:  "afbb3270513c81b8b9466499c3021142bf064f88f12276dbc497c74a4d91a7a3"
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
