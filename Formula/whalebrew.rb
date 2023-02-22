class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
      tag:      "0.4.0",
      revision: "bdf94887abf0397341c1d241974eea790626ae7c"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b261a5634eb50b002b2611c01c633d1f633cb9407f58f9659d565057bba82a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b261a5634eb50b002b2611c01c633d1f633cb9407f58f9659d565057bba82a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b261a5634eb50b002b2611c01c633d1f633cb9407f58f9659d565057bba82a9"
    sha256 cellar: :any_skip_relocation, ventura:        "aff7415c0ca2bbf63f06bbd53474f0870a5ce6259c6cbdf16778848d9c74c1ca"
    sha256 cellar: :any_skip_relocation, monterey:       "aff7415c0ca2bbf63f06bbd53474f0870a5ce6259c6cbdf16778848d9c74c1ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "aff7415c0ca2bbf63f06bbd53474f0870a5ce6259c6cbdf16778848d9c74c1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1b48ff5791412a01db7203c15164644bddecb122fb037e0b84dc0cc468523ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"whalebrew", "completion")
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
