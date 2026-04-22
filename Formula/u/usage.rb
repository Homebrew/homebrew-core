class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "f6da0088295fa095aab5bfb12c18b19cf91fbea25e4a081c6f5220799da39bbe"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33785e64c5c28e27d6f3471d5838f43dfd4a6b96d418917bb88cf383319378e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2131763f1fae840bcbaaef72f301bb1f8eb665c72ca7fe68783dd3e39dcda649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "903fa314f370294293e28d5c7f2efc824c49c3f3aabd2b87cf6fbb6dafaf842b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9769c8b4cb4bc891cca0d4f8c89b1c5b42f44bc47536a849c246ac43a8d83ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cedc0e3752765a882b742b1edc3cc72c0c80bbe444fac1e69e6ab14fbe58f99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0255b422257463bc42e939602eebc33a2669e87af887fad9c1f34f24eb92cb22"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
