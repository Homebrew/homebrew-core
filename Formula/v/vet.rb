class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.5.11.tar.gz"
  sha256 "aa4ae661bb99eb3eb45da2b3a139f7c4850d95d5c0e1b9f9ce497edd0eac6993"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddf6bcb4998856e803d751838b393ae5ce56e8f0c6df4840ffa3f8e5cef03ce4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01224f61f4e787cb66e5151b73ed0e3da1a60c3587b01c3594016b5552e8ffb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcd3b18277933d8125b24604f748868de18c07cf765a8b76fd84446b8c3dbb30"
    sha256 cellar: :any_skip_relocation, sonoma:         "68a19f2034c522d8246bb403551765e6c17ff97c8c43344fce163a8c27a55f6a"
    sha256 cellar: :any_skip_relocation, ventura:        "878eebf2996080609bad14fc81441175d40706cbb69550cd252ea3d3f7dba210"
    sha256 cellar: :any_skip_relocation, monterey:       "628a7e066dc0a6a6808b03b44cb330671e9348a1526c2a27fdbad7f96f7f4432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527c5ef38345f0331a2155994f8eee2ff07fdd10a1ce120f051d0c101c7bb874"
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
