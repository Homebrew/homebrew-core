class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "a0e0cb66932265aec2f03fd07507c1b4a94748b21fafcc29d1e3b57b19016e79"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "868e817bdfc7ede33ef6b77455171ac199b76f788d7e4699a53c1c4173869cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "868e817bdfc7ede33ef6b77455171ac199b76f788d7e4699a53c1c4173869cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "868e817bdfc7ede33ef6b77455171ac199b76f788d7e4699a53c1c4173869cd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf1b635aae0dc117fd21dd58250936e6ea76442edfc648fef5fc99bc47020a93"
    sha256 cellar: :any_skip_relocation, ventura:       "cf1b635aae0dc117fd21dd58250936e6ea76442edfc648fef5fc99bc47020a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7c9855bd541b7df9e68554dda7c0da09db3f2138f9ed8b3462b8c4c9ccc9d5b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
