class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "c74d7a3b1999aea3462efd8d773e690e2ea38a010452cee3fab3182c2715e1cf"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0964f6afb165d09f13d7995465d6213a659aec0fb1b83d21ce58c3bf42a0698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "befcae38b59deb9cd7fae0004da3acbb458a632eaf640c4025c0c6e9087cc1b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7e5d1daaaf5cc401135474e557280745545aea6c8d8be80b4995e4b2ee2ea16"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded10dd64ba06d5dc19f8c9d8fb7a239efe01fa54d4ec17d8f4b5509687ccfe1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35e650243e7a962595bb4a5cbcb3a03435fdff3c10042316036b8f5af518a530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d805cf9b2ff1cc3b77685a0ace49d4e0040308268561722c566599a267f491d8"
  end

  depends_on "go" => :build

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-s -w -X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"

    generate_completions_from_executable(bin/"temporal", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var/"log/temporal.log"
    log_path var/"log/temporal.log"
    working_dir var
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
