class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.91.4.tar.gz"
  sha256 "f0b6b645501f3767e04a3d95364165a1deacd7b54f693e1124bafe189ea79dbe"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53dcf5e703f672293d5444f99cbb45bbcfa384fab6961cb4bfa2eb16ed326f31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8742367b551a327fab444aa20eb3c26b5e12c3ec89a64a82329a0eb7a9c66f3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d50b43cebfeb076d733461fb8843845d3e7146dbe7fd5b053788de9662a0628"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48eaf80b142ea68668735416dcc853506577362dee216a1a92968569b562621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b0257bd9bfdaabea418b9365d97240a00502f518cdc924f053439bcc3ed60ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5ee9a7b9d29d81cbf410f0f5b7adda1608825e73d48a989e5ec69571ff0aecb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
