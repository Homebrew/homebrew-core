class Recur < Formula
  desc "Retry a command with exponential backoff and jitter"
  homepage "https://github.com/dbohdan/recur"
  url "https://github.com/dbohdan/recur/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "4009481a1fd752e50373f17cef5281332de451a3dd0d4ac1c268be380e52e1e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3bcc122de7abea710bd7c31174e22e4fc28c7c13cc5006eaa63ba34ec74a0fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3bcc122de7abea710bd7c31174e22e4fc28c7c13cc5006eaa63ba34ec74a0fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3bcc122de7abea710bd7c31174e22e4fc28c7c13cc5006eaa63ba34ec74a0fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "13473b39ef19c5b5e8bdf2203482d94b14601a2bc6924a92643f264dc3650acc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be512d445fae3619ce6f26f1d0ef7d5d515fb4d07b4a9dcbd7b2ff108ba922d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4764410cd5d9892e1386dd91c9f1050d0bbb7e1855d9e699fac21569b9aed6a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/recur -c 'attempt == 3' sh -c 'echo $RECUR_ATTEMPT'")
    assert_equal "1\n2\n3\n", output
  end
end
