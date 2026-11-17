class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "c7c0be5fa749106f06908e26b2d80399e1327fe7aefb8cecf3a27ce2fc09669c"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2faadacb463eb01a30a1d3008942b801578a21d4ad6c5b158531b2ba69a5927"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb81d1689ee709570317337cd7d15c8f3cf416425851b483dff2ca1e6f074fb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e6317fd8f880a50d9da628eb20cb06af588c288aa0cb6259e2d529c39d7cc39"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77522a7e4095a76bc748aaf0d5e556edba0d93067b6b7f0e209c1fcb3a38451e"
    sha256 cellar: :any,                 x86_64_linux:      "a445c3d00aa3e44dfabb778c8f2e5862d4e6680de9e6730716002f5f44ed1f65"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "http2legacy")

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match version.to_s, shell_output("#{bin}/steampipe --version")
  end
end
