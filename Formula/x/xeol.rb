class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "5e0d79a00b191c1fb950b350826966bfa28aa7993a8666cf2bf52f452af301c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "834c0966f109b5bb98df2988f16205dac8e1ec4bc8dd6ab48d3c1bf3f23db358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d25f80d8ad7ff85f10061004890782ac5f3b26c613d4ef881c17965d033aa88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b3b7a5bf361e3bb7431b12dde030e44c2fe482f44177f401b966bc14152d1e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e49c8d52941a9aa7828b3472c9ab0d45ca7f8ced54eed271afa0ea7efd70b34"
    sha256 cellar: :any_skip_relocation, ventura:       "0fdfc2749d0346201c9bd2fcc4a63ce72acb3d56a80e9ef85e4272751915dee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1240dac7c29ba68c1aae1e13285d24484fb8171ed1be02be6445e3d62c86b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end
