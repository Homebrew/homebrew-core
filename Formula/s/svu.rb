class Svu < Formula
  desc "Semantic version utility"
  homepage "https://github.com/caarlos0/svu"
  url "https://github.com/caarlos0/svu/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "2b1a2fc5bf804c80a9261686370bf882dcc092b1cb8e1605920fce7da7562f0e"
  license "MIT"
  head "https://github.com/caarlos0/svu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b84c4946391ababdae7dd7c853214e628a4b67927b27f8c358f99961dd5efb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b84c4946391ababdae7dd7c853214e628a4b67927b27f8c358f99961dd5efb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b84c4946391ababdae7dd7c853214e628a4b67927b27f8c358f99961dd5efb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "949992c142ab3234650ed39d8633067afc1cca27e6f436c379aa4c7ae7c28819"
    sha256 cellar: :any,                 x86_64_linux:      "def6dff8589a790941696b8b505784e7bad0011eb18ae201cfc2bda209bc81af"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user} -X main.treeState=clean"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"svu", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/svu --version")
    system bin/"svu", "init"
    assert_match "svu configuration", (testpath/".svu.yml").read
  end
end
