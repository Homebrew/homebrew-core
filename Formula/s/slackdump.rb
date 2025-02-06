class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "2a59e58bdd349d85855472bee6658a23029c678742d4adc2faf724bee587f482"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f532124601531183142bd25267396af6b004ce7debb519eaf32cf26c458f33c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f532124601531183142bd25267396af6b004ce7debb519eaf32cf26c458f33c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f532124601531183142bd25267396af6b004ce7debb519eaf32cf26c458f33c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "76aad857e3c9b63e937c44a495278f3d7fce694b24d67e2b87318c484be5996b"
    sha256 cellar: :any_skip_relocation, ventura:       "76aad857e3c9b63e937c44a495278f3d7fce694b24d67e2b87318c484be5996b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40aaf1ec69bda731a6731e167e273692546103397c7a3d53ffad5e8297044841"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "ERROR 009 (User Error): no authenticated workspaces", output
  end
end
