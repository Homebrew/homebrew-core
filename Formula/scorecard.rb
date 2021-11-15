class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v3.1.1.tar.gz"
  sha256 "94a471ce9002fce392c9b42d0678d6cddf7fb90c4784de4cc8f51ba2b6798c04"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe216e430cbb846841c93bf04bde3a8dfadba1e2e7e4ac78260cacb14a73a79e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b86de4a596ff886029dd82b42797c48bbc9171208d6f800e3cf790f654b51c0"
    sha256 cellar: :any_skip_relocation, monterey:       "fc81d80256474462adab81de9eab36b9aaa68daa49e5f0967c575f7c4cf9525e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bb9c2ff64b2f07bdd3cee3a59c626bd2fe5dbde11a0d4f4632c1ad14a03d24a"
    sha256 cellar: :any_skip_relocation, catalina:       "faa2942db6d92b88d4b976f3f6c2fe159ba84988414abf5f58dc7bf90690b4f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("docs/checks/internal/generate") { system "go", "run", "main.go", "../../checks.md" }
    doc.install "docs/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    assert_match "GET https://api.github.com/repos/kubernetes/kubernetes: 401 Bad credentials", output
  end
end
