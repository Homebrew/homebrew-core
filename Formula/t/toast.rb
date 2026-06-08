class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "fc1812435641b40bd63cf9dd0fd33d2a7a24ffeda6302ef5d71b78cd4c1a606e"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fff3b5222c5ce7f8c15270124a622493edde00b51deaf8302c0aec4fcae9cdf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06bb4489511563f14df1a7c31499c36af6e6610bf92dddfb0dd06db5d706c64e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd00feca039da607371b1f973aa27288778182619a11265a5bebd251da25516"
    sha256 cellar: :any_skip_relocation, sonoma:        "909167673eab78981ff664a1a7baeb1c856f921ef2fde06fe51cb51878ecca7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8901b4388dc181a637cfdf55115b5508152dd8396eece19abe244314058f4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab63e66978e6ac906489f5b9dd7e6552d804fe8ffa207f91d9f1d27becbf811"
  end

  depends_on "rust" => :build

  conflicts_with "libgsm", because: "both install `toast` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~YAML
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    YAML

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
