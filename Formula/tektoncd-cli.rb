class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.29.0.tar.gz"
  sha256 "ac3a979cdcdbc42354d0245cba0a4ac4ebc5f332bcf90685dda941a28a224682"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf4bd29c4357e99df4edecf761c5fd4c41999d3c00490e8b6f58d885a2dd3242"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad5f915d0c89ff1675e96812893b9c3907bb8c139e0cbfa8935905bd96f308c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "394394649fbf1aed03fa12c640a942aa02017628f168c256dea59a147b0ca59c"
    sha256 cellar: :any_skip_relocation, ventura:        "37c2ef6f6b461990bb741ae5a98dd5a7f9201897d23777671d431d0f62e8d0ae"
    sha256 cellar: :any_skip_relocation, monterey:       "a22b88e572afe7b20b665d6c84dac8a2f3346783d663d0589fe1be9372717425"
    sha256 cellar: :any_skip_relocation, big_sur:        "36a569fbf8dc43a58457a8c903d359323444c91c97aa5c60ea1210e9241fbaa5"
    sha256 cellar: :any_skip_relocation, catalina:       "cf07680315f35bf4159b182b22f165ce43f89a4761871f1563c71f9e979a775c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d3bab952da50d5018abfe1c8de9a5bcc2ec046757aa353e30ea8067de64e2d0"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
