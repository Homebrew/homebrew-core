class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.36.0",
      revision: "dd573535e79b343967fc29503a2537df8de340f7"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a7b209b3804917ca0ef40d5678ade7781870c426a066b9710791e35b9a007c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "561f455a090278933b4a1310686e90313239e080b11f8afb7459fb55d2e96192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66f8b7668b9f3dee49649536807329e2b211e215bba1a2e4b1e561da2c7f2174"
    sha256 cellar: :any_skip_relocation, sonoma:        "6579a8a25b53bc31a56d5e5df83c00ea410a187f4a9d1fbfe444a0dd9ed30d7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "948c08fbdf77defcc7b89fd2653e1ebfe66279aa115d600a11362ecf42d3dd76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3703e7b58f462a3cb1417019d5a72a5ff0500dd543bf88c47650c25f32b451e"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "yarn", "config", "set", "ignore-engines", "true" # allow our newer node
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
