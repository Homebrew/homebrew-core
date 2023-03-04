class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "99c3c758c4bd9e9b95100d0ff0eab9b6788e70c44a0edc026d3331982fd1754e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82f5eeb13394e6379a99154316d1f2e7a7d12918f8a3c990afcad2f047324f2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d7a1e664dfb53e04a0ab4f4e70f54e59c350348b3bb2115fbc705e2bce21d57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bde129bc73afb0c759d15ea626d48c8ecbda0e5b14a393896f2a6f1045ab8b8d"
    sha256 cellar: :any_skip_relocation, ventura:        "86816d1a8a678fe01b512a07f3df89cd7c905ceac8ad28a7481cc25a33e9f64e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9017a34ff4c33665f1b6cc18e03c7f45aca46830dd7f3fe3b08931894628dd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "00b9c48269a43bd00fb1f425e0584a545bedcbb450e70e1dbfe0895e867b29f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3161d85dd33dc5bdfb349751f10bc51bd7f03968136e00f4af644a8e24a6a9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "cli version: #{version}", shell_output("#{bin}/tetra version --client")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
