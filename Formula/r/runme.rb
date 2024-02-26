class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "7f3ac2ba6c2907287f13c353557e5a2d599c44e6abeaa71775eb6f86daa19670"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8fb6b6c6b3ee65fd8ee8b24fe9e85bec007afb89623f7fc40a83705d9e182de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd86b7c4ff86b8eeac245a52f3e9fbff6bef6397192553d0e8e021d09e7f2a6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d96dbc75dca1a2e86509806ad8add6190613f0216efdb2ae56574018db2ca81"
    sha256 cellar: :any_skip_relocation, sonoma:         "cacea0b5986575d0570872c9cd2f38d16f5dfb31aa3bffa481bcab2a3a84105a"
    sha256 cellar: :any_skip_relocation, ventura:        "936001bf873ea054ae90f3d95183c72f40c9b785de6dcf2cbac767bd9f53f144"
    sha256 cellar: :any_skip_relocation, monterey:       "c60171c845adba8566f7107dfc9863212f128d37320fc64fb828f153c63dd9e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54d321877af3a0eb2fc73b119ffc8525877464a1d0f8f1f816a469429db01d8"
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
