class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "942427701caa99a9a3a6458a121b5c80b424752ea8701b26083841de5ae43ff6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "494136cea6aa2305a857c2a9091558c37516fbe4cbfe1466089cb041c56ef64a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "494136cea6aa2305a857c2a9091558c37516fbe4cbfe1466089cb041c56ef64a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "494136cea6aa2305a857c2a9091558c37516fbe4cbfe1466089cb041c56ef64a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2540f33549ba66fc0db57e7ac1d33c9b94abad914d5134a8946aff8c04bece3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2129b6933244680b5e70c3a1636988ee5d2e1800a0dd8d2f3aed397453d015d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d07a3ae592c55324e85305316310fad9c8d78d897a3705739071d0275fe5f472"
  end

  depends_on "go" => :build

  conflicts_with "run-kit", because: "both install a `run` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath/"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}/#{name} #{task}").chomp
  end
end
