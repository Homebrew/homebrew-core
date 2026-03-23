class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.11.tar.gz"
  sha256 "7198e1526c93b91095228bc6e00b3d8b7f5f29b4058721d4d523726572b77c2d"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cae0ecc7d396439e9be3842f1211e4fd49f5e30459f3f582f4ec8dd99fbced97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1f0dea8e1a8a672d31ccb905f3563fb2eaa4f425f5915b4aef7e4f0f95e5077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d3fb543ff7a7a4052429e9e7c78275851cffff6871809d4aa16b4c3002a6dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9f2166f9030963d9c63cf752bc84a12d3f6b367f6a8e45d2bfed5b004d5923d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238c0b3c443245b9f6e9570fb90f3586282bc0924dbe3ba73a1b5830bd672c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aa94ee7f65739698599b27cf82c5c651d5f74db47a86b4ee077b71a458c2930"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "aws", output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
