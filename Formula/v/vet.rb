class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.5.10.tar.gz"
  sha256 "2269c5e9e6e57be59907f4aab6e96189fc9a08fbc92323376af3e0a6def2c1ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce3b9054e55f82c66aa9891c88abdd379897a756bb4f73ef67315b4d64c8a47a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9b26f3308da05a1243036bd149ebcb3dcdfbc3014a0e68072e252c4d0dbdbe8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d7c46d9f7b915571bc83cd36a16c554f74f41ca1b68b5219719062558688f19"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbe4aa946df94b7991fb37dc5ab15ec7621f092301f674482ba0edc36239df5f"
    sha256 cellar: :any_skip_relocation, ventura:        "6ff5884b6e9684eda7f3ad51f9e5eb0b5c0fda604c52a62fb13412a3032839fa"
    sha256 cellar: :any_skip_relocation, monterey:       "d957714fd2f6401a8ad8ec5e61d2d2426c066e5a89419c18f89e16ea2ad27db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb452dc52ccea175240332dcebf9a70a706e9c75b411084fa94589b78d019e68"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
