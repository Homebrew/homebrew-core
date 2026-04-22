class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https://github.com/abhimanyu003/sttr"
  url "https://github.com/abhimanyu003/sttr/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "64c4ddd6f84c99f197053e96c489dea48c0bd83a33dfdd69ab209653bc38b9c8"
  license "MIT"
  head "https://github.com/abhimanyu003/sttr.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b39d24d4c8cc8e75d384bbd42bd9bd22a7da7ac5954b3ee6d1652cbbd9c9d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b39d24d4c8cc8e75d384bbd42bd9bd22a7da7ac5954b3ee6d1652cbbd9c9d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b39d24d4c8cc8e75d384bbd42bd9bd22a7da7ac5954b3ee6d1652cbbd9c9d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "20b9c91d03c9c512dd4f00d557e514f06cc17c44f3341153c2b61e3f4c933b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f4a64e268d9c4e296016ad939191a88a07e5fa852ba4e22e887d90f015047c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253fef747f7bd342a2253655912062395c5bac02ed98435f38c25ad86b1c5b3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    generate_completions_from_executable(bin/"sttr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sttr version")

    assert_equal "foobar", shell_output("#{bin}/sttr reverse raboof")

    output = shell_output("#{bin}/sttr sha1 foobar")
    assert_equal "8843d7f92416211de9ebb963ff4ce28125932878", output

    assert_equal "good_test", shell_output("#{bin}/sttr snake 'good test'")
  end
end
