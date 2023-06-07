class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.0",
    revision: "782f93d648da78d4b659c03028eeb0588380febe"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a80a6517621eb5ec9bf7252ea19c7bfa15b03d9fd0171d4b1f3a0e23f40e35b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d18426e06155b3206421e5da826d696dabcc132298cf3a4184c7fcfe114eb4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c68d75e3c40da1e37a450585235770d4e68196f1c754327f173ba2859f1cdd"
    sha256 cellar: :any_skip_relocation, ventura:        "e4cf87fd350fc9f2c05fd963b10526daa33a28ca3665d0d19549ecb62bc5ff3c"
    sha256 cellar: :any_skip_relocation, monterey:       "1128a67b330023b88d857fdfd7e2f499ca5644b2afbf516342ef34c2046d9813"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdae16b2a5a78bff5c126e40d03b68131c4b7bf82bdf00c2d5f8815875ee3dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e70e6c7e2438d1b7b6c54e8155ca6328d8c7a4e29d98e3e52d2c4af50f843dd0"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"

    generate_completions_from_executable(bin/"yorkie", "completion")
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
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
