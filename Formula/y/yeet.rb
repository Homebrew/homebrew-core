class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c363197076eec9f9d5be2f6c72ae06437a2093816105d217d165c6a308da2985"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f35f96e7781ecdf80ca4cca12115a7b6901b21027680dc08ef5b54d3c54aa08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f35f96e7781ecdf80ca4cca12115a7b6901b21027680dc08ef5b54d3c54aa08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f35f96e7781ecdf80ca4cca12115a7b6901b21027680dc08ef5b54d3c54aa08"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f3205f3bac9f1e1c312f0387e30c36b06c11044252b484e0221b5bd8ac15915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0569a38c7c89cca2be5363f4745efc3aa52a61349707271de3319857cf461fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffce44bd9550ebbfca38541ddc5e9fdade9b09972a245c3e9b7695603d1a1d15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/TecharoHQ/yeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/yeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}/yeet 2>&1", 1)
  end
end
