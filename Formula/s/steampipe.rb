class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "76ad372e658406ca38c2cb4bf5b2f79cf5068aaddb6a2c21d638cb8256ef16c1"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "96623e2bb6e64a281468824e2fe23241ac3b9f82c2d1b26300a77a423b584393"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd5f627a7b822fa18e3305b8c98048c84c8182c6a774edce399c7d92025b6cc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d841befae8fd81cea4d64328badd44ba7ea945fed85513a6fab833a4771afe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c68e154c6a2c561cae02df6619434b27c23426e3e6a9d5ac99c573ae4502d288"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "871a92e1735b21a3bc9839d1480ae8cd1ae3c3a1ea8f1910f0d377a859c9d536"
    sha256 cellar: :any,                 x86_64_linux:      "c8e91f332ae439ee10c48a00a8c1654403ce6a07694b679271cbbba466b41457"
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
