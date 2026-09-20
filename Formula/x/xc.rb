class Xc < Formula
  desc "Markdown defined task runner"
  homepage "https://xcfile.dev/"
  url "https://github.com/joerdav/xc/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "afcb5e1fbd1be5f0b6dcb802e02c96527ac0e96ddeb47471b8ad4056f91ccc72"
  license "MIT"
  head "https://github.com/joerdav/xc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "218f640198edf48b9a9df52fbb9a0bb29c208e03496a2d3006f7ba019f4595af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "218f640198edf48b9a9df52fbb9a0bb29c208e03496a2d3006f7ba019f4595af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "218f640198edf48b9a9df52fbb9a0bb29c208e03496a2d3006f7ba019f4595af"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1aa3609e31321026ef590aebb04b5d0aaf1e4485eba76d93bc268e4c254d3f3f"
    sha256 cellar: :any,                 x86_64_linux:      "cb3550770d7618a22bc32ba3ce2f5320f878bd3bbefd8b4d4b9a3e5ce28dd233"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/xc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xc --version")

    (testpath/"README.md").write <<~MARKDOWN
      # Tasks

      ## hello
      ```sh
      echo "Hello, world!"
      ```
    MARKDOWN

    output = shell_output("#{bin}/xc hello")
    assert_match "Hello, world!", output
  end
end
