class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.7",
      revision: "2b3a4064c6ba84e86c93258c085b498e5364a44b"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29d86973a163e2c6d66c4761cd507a89914637b9a2367cd4381a639e550c1629"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaad8c4643c5e033f5b3589b2a812b0f24f3e36c0b85fdc3363d93c2451be751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d968916e24f29dda891bff7c862dead951142c6e13e9bc6835c48ad5bca47f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d1ed6d0508132a0c6df2e01deee7a3919660eb05e3706b1db902d9a38c8cfa6"
    sha256 cellar: :any,                 arm64_linux:   "203c6ac8d7ddf2112d1ef6d2e188c0a06715e9b08ef561a993e73fa69b60cec1"
    sha256 cellar: :any,                 x86_64_linux:  "5498d06066bd33ee28ca41f0e79ffcacb9dd7d7f611e5c5d2bf9ec34d4f2e8cb"
  end

  depends_on "corepack" => :build # for newer yarn
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
