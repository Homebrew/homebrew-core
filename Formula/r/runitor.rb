class Runitor < Formula
  desc "Command runner with healthchecks.io integration"
  homepage "https://github.com/bdd/runitor"
  url "https://github.com/bdd/runitor/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "7c245db0bbd211a62e8adab1d78ce59ab8cb02147c95d3713508a75cc0f09099"
  license "0BSD"
  head "https://github.com/bdd/runitor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae097b06f663c5c098e966e5737cdda3a938960d6bb91362cec21f1ccce2e661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae097b06f663c5c098e966e5737cdda3a938960d6bb91362cec21f1ccce2e661"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae097b06f663c5c098e966e5737cdda3a938960d6bb91362cec21f1ccce2e661"
    sha256 cellar: :any_skip_relocation, sonoma:        "51ea31e203f0f305ea29997a2549ea4f45ee5f212e2ec54c299fadbbc0643420"
    sha256 cellar: :any_skip_relocation, ventura:       "51ea31e203f0f305ea29997a2549ea4f45ee5f212e2ec54c299fadbbc0643420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e0b3720e73ce9e0ead9c92612d8fe7c7437b19996046b5975ac96c545db338e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/runitor"
  end

  test do
    output = shell_output("#{bin}/runitor -uuid 00000000-0000-0000-0000-000000000000 true 2>&1")
    assert_match "error response: 400 Bad Request", output
    assert_equal "runitor #{version}", shell_output("#{bin}/runitor -version").strip
  end
end
