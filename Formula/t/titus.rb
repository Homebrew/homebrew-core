class Titus < Formula
  desc "High-performance secrets scanner"
  homepage "https://github.com/praetorian-inc/titus"
  url "https://github.com/praetorian-inc/titus/archive/refs/tags/v1.2.11.tar.gz"
  sha256 "757f14f8d51a9a6e7d7b76bf26b3a5491925323b3b03d3e7cddaaed2d3815c3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a3ab9d71cbfbc8a90eb77af2b1cc3027c93813c0a0d7c1a1eeb3c6771d4e8391"
    sha256 cellar: :any, arm64_tahoe:       "5523988ff8270965bb81199366e7adcc48cdc24d2048c92e448276de9500275c"
    sha256 cellar: :any, arm64_sequoia:     "ff4d8ca75f2d173d5e89c961ecfc56cdb10a32938f7ebaa66d6a5886f06f0074"
    sha256 cellar: :any, arm64_linux:       "efc35cec463fc095f08dfb91ba202b076912fd200828dc08e488b74e1c157013"
    sha256 cellar: :any, x86_64_linux:      "79d88dea8c85422cfaf26bb01ea8f2a81d6e439e505eec9c19a1d3f5da106600"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "vectorscan"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", tags: "vectorscan"), "./cmd/titus"
    generate_completions_from_executable(bin/"titus", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/titus version")

    output = shell_output("#{bin}/titus scan https://github.com/homebrew/.github 2>stderr")
    assert_match "0/0 new matches", output
    assert_match %r{[1-9]\d*/[1-9]\d* rules compiled for Hyperscan}, File.read("stderr")

    require "utils/linkage"
    libhs = formula_opt_lib("vectorscan")/shared_library("libhs")
    assert Utils.binary_linked_to_library?(bin/"titus", libhs), "No linkage with vectorscan!"
  end
end
