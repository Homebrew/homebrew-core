class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "b3422daad4ea049eb5146f6cd2f04cb252bfeda8789b0cfe10111a608270764b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99905cbfcdf3d2fdba4c2a12e205e49983e7ce6cd8bde41942578e11ac3aca84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480f5b8b85158aa06bf86976e541b072943c33abe3466d3827c0a1ec19e1d59c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4040f2d876229aa4fda4037043cd37d2591148fb19959f3cd2bb560f8fdf56a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fcb5466d60d05c55e374c7ad53297d411c3dfb96bcd39b3b7ff0e4b9403e6e6"
    sha256 cellar: :any_skip_relocation, ventura:       "380bbca591d7682f5a6be0e5e3b52a32ac4ae63899624943ab291cdee9506ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45837587c87a86c39615199ea168ab54b5aeec9fda293ec4a31f98d8ddf87693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fde63af85e70b12e0323752041abfbd3b2b5006397203ffa7322fd1c67c800e"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
