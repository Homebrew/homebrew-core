class Redli < Formula
  desc "Humane alternative to redis-cli with TLS support"
  homepage "https://github.com/IBM-Cloud/redli"
  url "https://github.com/IBM-Cloud/redli/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "a75de85b90466a088e39885b67c38cb3e7ceeee6f1ec82df3d1d88aee5a17a20"
  license "Apache-2.0"
  head "https://github.com/IBM-Cloud/redli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "551d5aeaffbb3b043b44b4e18fc830747719372caf61cb6955bc1ad08887b775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "551d5aeaffbb3b043b44b4e18fc830747719372caf61cb6955bc1ad08887b775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "551d5aeaffbb3b043b44b4e18fc830747719372caf61cb6955bc1ad08887b775"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6c3cc589ffcc8269d1bb58c22cfb978fba14a49a4fb5953af1715cbdb0ec673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d20057530e78c3f6809cf3398a12818ca83c6d3cfb7ffa530c85197da60744"
    sha256 cellar: :any,                 x86_64_linux:  "767190199a53710edb1add14ce5a407176b364a62246c4e536ded304400956e1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redli --version 2>&1")

    output = shell_output("#{bin}/redli --debug --uri redis://localhost:1 2>&1", 1)
    assert_match "connection refused", output
  end
end
