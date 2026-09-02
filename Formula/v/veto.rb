class Veto < Formula
  desc "Cost-aware AI model router with structured admission decisions"
  homepage "https://github.com/oleg-koval/veto"
  url "https://github.com/oleg-koval/veto/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "8c98a36e813c43be57172866b773bd2f76fdc6d729db6070aaeed1db94b459ab"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/veto"
  end

  test do
    assert_match "veto #{version}", shell_output("#{bin}/veto version")
  end
end
