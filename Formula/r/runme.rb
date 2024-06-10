class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "4521473e0f992b8c8cc9955ce9de07ba69bf36fd3ffec1d4351efe2783f2427a"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fa9ba782befc92fe4281e92813c02a2e00e91417666ee006cc75828084c6ddc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d43938eb3742634033710348db8f545d2f27f768199c1129cd784f829335c1ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f90f619d517028243df2a724488f64b276378424fc543fd05edb06a992a1f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "09a6f5c6c1efd7cb966e6cbdec6a36c4d2b95d854cca776c94dff103e7ba14f3"
    sha256 cellar: :any_skip_relocation, ventura:        "b756cc4a50d8f6dd84f3c5435a3ecadbff6ac3b714dc8271832f193e2cd9a408"
    sha256 cellar: :any_skip_relocation, monterey:       "8ffb09fc6d3b49567c535952a4ea91d386e9554f7abb52562ee5d6a353c4c794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03cc050e984ee70ae7c1a3c068194c0c8305bc090f8577b9c34cc14129a4e12b"
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
