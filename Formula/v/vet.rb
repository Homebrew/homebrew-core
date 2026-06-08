class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "16ef51326cd7c04e24224bb0cc4d5fb18192a730426845de6da4ede27a7e64b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62628bf22434e3d1f91b53bacb3452b91de84d19ea51ee8fddf526485146b1f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38731975fd0bf2d7e19316ffb5c6374c4f35e8b500d8e30c1cd9922fa3b85fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb58427def8783e20ebefe3df41f7237833bfedde3c6342a660869db17dff517"
    sha256 cellar: :any_skip_relocation, sonoma:        "bce777b4b94ff58d8a8852f52116367c2faa3005c4f040c9c35056d9fc812348"
    sha256 cellar: :any,                 arm64_linux:   "2e120f1eb6e600dfa1ae8a443561bdb89f71b47f80a67c2435e6a4325affb488"
    sha256 cellar: :any,                 x86_64_linux:  "5fe67046dd845cbf97ea65b1a57ad63537bb28eb9d40ff13639d3adac15c531e"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
