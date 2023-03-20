class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.32.0",
    revision: "448b120bc538b43874d13ce988a0438580d7ddeb"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9a4bba685c3b6bc65cec31234adda566ed3dd82544fcd80a3ca60b0959d1177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f427fe8d688b8f8a9f2c21cc48d9ecf917a3eebc9049498b863493699d1995b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd11e221bbb1b7c29afc02f3aad93d7216b3624075982c36a9376ff90fa8976f"
    sha256 cellar: :any_skip_relocation, ventura:        "6320e6fcfc25bd765f2fcb2a2b890fb8d9b05dcbe374bb89377ee213a899b7e6"
    sha256 cellar: :any_skip_relocation, monterey:       "117bcf2d52951bba8450c0417025f3ebb29e19ea9e82e774587405a19cb9bc28"
    sha256 cellar: :any_skip_relocation, big_sur:        "03aac0b67c0707eb0d556c8f29b84a0f0a3a315c9f5f24bc82b5c7be84db9634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46ce25641cf50c5681dc7f2d31dde4dacd0dbf678f5fb50e06266b9e035e835"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
