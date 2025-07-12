class Yutu < Formula
  desc "Fully functional CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu.git",
      tag:      "v0.9.10",
      revision: "a074d5564d4c7eb562dc11108b5ca06f842029bf"
  license "MIT"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06738845be37b5af38326ce2d5d589ca73f1a71dd0eb315ead52967b54094651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06738845be37b5af38326ce2d5d589ca73f1a71dd0eb315ead52967b54094651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06738845be37b5af38326ce2d5d589ca73f1a71dd0eb315ead52967b54094651"
    sha256 cellar: :any_skip_relocation, sonoma:        "450807c5b5a1e0fa39df551a1677f23f4189b2fe13f425840f5b09d728378a5d"
    sha256 cellar: :any_skip_relocation, ventura:       "450807c5b5a1e0fa39df551a1677f23f4189b2fe13f425840f5b09d728378a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf4c6e6cde1cfa1e3e11da5e683d8e5b80c840baba1b5e223ea70b72448e3093"
  end

  depends_on "go" => :build

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[-w -s
                 -X #{mod}.Os=#{OS.mac? ? "darwin" : "linux"}
                 -X #{mod}.Arch=#{Hardware::CPU.arch}
                 -X #{mod}.Version=v#{version}
                 -X #{mod}.Commit=#{Utils.git_short_head(length: 7)}
                 -X #{mod}.CommitDate=#{time.iso8601}]
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"yutu", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    version_output = shell_output("#{bin}/yutu version 2>&1")
    assert_match "yutu🐰 version v#{version}", version_output
    auth_output = shell_output("#{bin}/yutu auth 2>&1", 1)
    assert_match "Please configure OAuth 2.0", auth_output
  end
end
