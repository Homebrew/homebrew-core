class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "6d3c9f0972af4dda493a948651ec43e9acd780baa56e07535bc5da470bc6b104"
  license "Apache-2.0"
  head "https://github.com/kubevirt/kubevirt.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95d788cdccaf37337fc78eaef946c54dad61cefc0cf8cc41d416e2f5304cacce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ebe19d16c3aa39d798b859b303fe045cf4bf3fe22811739a32904abd3ea69e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57be6151baea712e5b36fa0fb8230f3246dec57a04da68fa0bb3893411458ae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1112c0703ab3ea08cbc213b262ba668b51f457db71eada3c4b649feba707c96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d186f688db00827c94a1beef0833e387b5bf75d0d0b543a8b905d409a874a36"
    sha256 cellar: :any,                 x86_64_linux:  "9589327e6d91fcbe3578458f743bf6d656e5c4a6cc962a9132b0bb22d37a1a73"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
