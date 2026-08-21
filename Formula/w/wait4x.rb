class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://github.com/wait4x/wait4x/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "36b1e0d3e7894ab20d29dfed19ec306c19e94608c2cb1a61ef5084d5127dfca8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4da6bfdb8a6dc72b8ac91582928f8948ca7cf6f78f8cb79abc255115e5746e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76ee44ccaa3a6e7572a93fafe409ef2a28fa28147551bfaabe0e7da7a9f39d82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d21d37a78296987be49ac49ba3ef618aa89920871402ad4b9977ae3c724ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cbe17c4dccc6bc02b0a32d952a8e20e05aebb4b88b89b60afe0da105a7f3f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c554115fa790e91f6c42ba600ac7bac454eb78b1355aec6157150e1d3cf1645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a94b6e7f58cdb63547b00ab415245f97cdd65c86a588693f06e0f115b053948"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "dist/wait4x"
    generate_completions_from_executable(bin/"wait4x", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end
