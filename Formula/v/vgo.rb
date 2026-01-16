class Vgo < Formula
  desc "Project scaffolder for Go, written in Go"
  homepage "https://github.com/vg006/vgo"
  url "https://github.com/vg006/vgo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "262ab18eb8e2f68031e17727c1c8b0e01e61c385dcd7addbd2c1ae86ecd312b4"
  license "MIT"
  head "https://github.com/vg006/vgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff3f68e2c54740a2b3cdd2074e33ba392fc4d4398c7ab77c441f96b5294cd4dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff3f68e2c54740a2b3cdd2074e33ba392fc4d4398c7ab77c441f96b5294cd4dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff3f68e2c54740a2b3cdd2074e33ba392fc4d4398c7ab77c441f96b5294cd4dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f6d163d6dc4217b8501804008210bdba10fd415b31112d4d78da74e351219a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d885ec1ff53867945a651083c1c1db6b0aa08fb5eef94f4bf05e47fa65e64b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea7f580c8df4839b99a44f522001776ec0dba68b005afff0b08cc567aafbdd1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vgo", shell_parameter_format: :cobra)
  end

  test do
    expected = if OS.mac?
      "Failed to build the vgo tool"
    else
      "┃ ✔ Built vgo\n┃ ✔ Installed vgo"
    end
    assert_match expected, shell_output("#{bin}/vgo build 2>&1")
  end
end
