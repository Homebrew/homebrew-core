class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "e9787ddf747344dc7db677f9bdc6c2b1025b9de665baf2741d7653488b24cc51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "675adecc67dabb1c4b60b3a5e4bea3bd20fc525b2128f09a529f7a9bb5af6b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8ffdecd75e75ea46189d77276190f6c9f01e16e0f6cfe6af8e6b1f98da4ff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79e124435d0a29451acc14feac28a46caba839dd04cfccbb4efccb47b3624cce"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab296728fc492fe59a368359caeb1638fc937fe60cbe8baa42e25445226edbc1"
    sha256 cellar: :any_skip_relocation, ventura:       "af3f5d623de151c2e7f72509db8247eed1124e9f9c65148f8768d082879d6b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf3ead70378843f7ff6c50f1e3d51a75538c80200d84f625c144a688237297a0"
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
