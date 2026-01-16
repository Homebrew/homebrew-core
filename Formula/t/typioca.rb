class Typioca < Formula
  desc "Cozy typing speed tester in terminal"
  homepage "https://github.com/bloznelis/typioca"
  url "https://github.com/bloznelis/typioca/archive/refs/tags/3.1.0.tar.gz"
  sha256 "b58dfd36e9f23054b96cbd5859d1a93bc8d3f22b4ce4fd16546c9f19fc4a003c"
  license "MIT"
  head "https://github.com/bloznelis/typioca.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31591811d9bcd2c334d1c82cd42b775dcda3fc16434fd1281bf3ec26f96c91b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31591811d9bcd2c334d1c82cd42b775dcda3fc16434fd1281bf3ec26f96c91b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31591811d9bcd2c334d1c82cd42b775dcda3fc16434fd1281bf3ec26f96c91b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a37ade2bea15ebd66b6dd3115606e1cd073a236e7591dbd3d4e70f382861f1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2674e97e8860983277f7d6aa91543e5f809ec1790236640f6f64f472ed3dbafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8ea7d501020dd958c5a99eb9d82f4f9d9f46158483655eb67439c2a00b2db4a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/bloznelis/typioca/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"typioca", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/typioca --version")

    pid = spawn bin/"typioca", "serve"
    sleep 1
    assert_path_exists testpath/"typioca"
    assert_path_exists testpath/"typioca.pub"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
