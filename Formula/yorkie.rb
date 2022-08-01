class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.13",
    revision: "0cca5e25b8b83ad5b389f84735324a016f9691f9"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf51dfd6da4098091f48698645aa459331c4e5553bc08de8ad7a909b4a9ed1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f957da810b7f1cf514f87d9b7a56f9b9ddc46adc6babc9e4ade4618e336d65d3"
    sha256 cellar: :any_skip_relocation, monterey:       "2b766ff897dadd0e55950d7c7a02ab1b02c5829e51433f294084c7f44305f7bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "da4de907109e36d42866752fb77bdf2b70833ad9b598149674b5fe697eeffee0"
    sha256 cellar: :any_skip_relocation, catalina:       "0a07b6e773941a452920e5e5c3836245af0253ea8a58dfb1a998ac1c62e149dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a2488fedc8d33e5cd7fffd222b3714b204487b9cfc3d0f148ccbd2510b43ef9"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
    # sleep to let yorkie get ready
    sleep 3

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project}")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
